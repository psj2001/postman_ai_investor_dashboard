import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WithdrawDialog extends StatelessWidget {
  final double revenueSharePercent;
  final double totalIncomeTillDate;
  final double equityValue;
  final double totalProfitWithdrawnTillDate;
  final void Function(double amount)? onWithdraw;
  final void Function(double amount)? onReinvest;

  const WithdrawDialog({
    super.key,
    required this.revenueSharePercent,
    required this.totalIncomeTillDate,
    required this.equityValue,
    this.totalProfitWithdrawnTillDate = 0,
    this.onWithdraw,
    this.onReinvest,
  });

  double get withdrawableAmount =>
      (totalIncomeTillDate - totalProfitWithdrawnTillDate).clamp(0.0, double.infinity);

  static Future<void> show(
    BuildContext context, {
    required double revenueSharePercent,
    required double totalIncomeTillDate,
    required double equityValue,
    double totalProfitWithdrawnTillDate = 0,
    void Function(double amount)? onWithdraw,
    void Function(double amount)? onReinvest,
  }) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF0F3FE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: 20 + MediaQuery.of(ctx).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _WithdrawBody(
                revenueSharePercent: revenueSharePercent,
                totalIncomeTillDate: totalIncomeTillDate,
                totalProfitWithdrawnTillDate: totalProfitWithdrawnTillDate,
                equityValue: equityValue,
                isMobile: true,
                onClose: () => Navigator.of(ctx).pop(),
                onWithdraw: onWithdraw,
                onReinvest: onReinvest,
              ),
            ],
          ),
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (ctx) => WithdrawDialog(
          revenueSharePercent: revenueSharePercent,
          totalIncomeTillDate: totalIncomeTillDate,
          totalProfitWithdrawnTillDate: totalProfitWithdrawnTillDate,
          equityValue: equityValue,
          onWithdraw: onWithdraw,
          onReinvest: onReinvest,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final pad = isMobile ? 20.0 : 32.0;

    final body = _WithdrawBody(
      revenueSharePercent: revenueSharePercent,
      totalIncomeTillDate: totalIncomeTillDate,
      totalProfitWithdrawnTillDate: totalProfitWithdrawnTillDate,
      equityValue: equityValue,
      isMobile: isMobile,
      onClose: () => Navigator.of(context).pop(),
      onWithdraw: onWithdraw,
      onReinvest: onReinvest,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
      ),
      child: Container(
        padding: EdgeInsets.all(pad),
        constraints: const BoxConstraints(maxWidth: 500),
        child: body,
      ),
    );
  }
}

class _WithdrawBody extends StatefulWidget {
  final double revenueSharePercent;
  final double totalIncomeTillDate;
  final double totalProfitWithdrawnTillDate;
  final double equityValue;
  final bool isMobile;
  final VoidCallback onClose;
  final void Function(double amount)? onWithdraw;
  final void Function(double amount)? onReinvest;

  const _WithdrawBody({
    required this.revenueSharePercent,
    required this.totalProfitWithdrawnTillDate,
    required this.totalIncomeTillDate,
    required this.equityValue,
    required this.isMobile,
    required this.onClose,
    this.onWithdraw,
    this.onReinvest,
  });

  double get _withdrawableAmount =>
      (totalIncomeTillDate - totalProfitWithdrawnTillDate).clamp(0.0, double.infinity);

  @override
  State<_WithdrawBody> createState() => _WithdrawBodyState();
}

class _WithdrawBodyState extends State<_WithdrawBody> {
  bool _withdrawn = false;
  double _amountWithdrawn = 0;

  static String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedWithCommas = integerPart.replaceAllMapped(
      regex,
      (Match m) => '${m[1]},',
    );
    return 'AED $formattedWithCommas${decimalPart.isNotEmpty ? '.$decimalPart' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.isMobile ? 16.0 : 24.0;

    if (_withdrawn) {
      return _buildSuccessState(context, pad);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdraw to Bank Account',
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: widget.isMobile ? 18 : 20),
        ),
        SizedBox(height: pad),
        _buildInfoRow(
          context,
          'Revenue Share %',
          '${widget.revenueSharePercent.toStringAsFixed(4)}%',
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Total Income Till Date',
          _formatCurrency(widget.totalIncomeTillDate),
        ),
        if (widget.totalProfitWithdrawnTillDate > 0) ...[
          SizedBox(height: widget.isMobile ? 12 : 16),
          _buildInfoRow(
            context,
            'Already withdrawn',
            _formatCurrency(widget.totalProfitWithdrawnTillDate),
          ),
        ],
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Total Withdrawable Amount till date',
          _formatCurrency(widget._withdrawableAmount),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(context, 'Equity Value', _formatCurrency(widget.equityValue)),
        SizedBox(height: pad),
        const Divider(),
        SizedBox(height: pad),
        Container(
          padding: EdgeInsets.all(widget.isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: AppColors.sectionBackground,
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.textSecondary,
                size: widget.isMobile ? 18 : 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This is a demo dashboard.\n'
                  'No real money, banking, or withdrawals are involved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: widget.isMobile ? 11 : null,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: pad),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget._withdrawableAmount <= 0
                ? null
                : () {
                    final amount = widget._withdrawableAmount;
                    setState(() {
                      _withdrawn = true;
                      _amountWithdrawn = amount;
                    });
                    widget.onWithdraw?.call(amount);
                  },
            child: const Text('Withdraw'),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState(BuildContext context, double pad) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdraw',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: widget.isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: pad),
        Container(
          padding: EdgeInsets.all(widget.isMobile ? 14 : 18),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700, size: widget.isMobile ? 22 : 26),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully credited to your bank account.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w500,
                    fontSize: widget.isMobile ? 14 : 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_amountWithdrawn > 0) ...[
          SizedBox(height: pad),
          _buildInfoRow(
            context,
            'Amount withdrawn',
            _formatCurrency(_amountWithdrawn),
          ),
        ],
        SizedBox(height: pad),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onClose,
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      fontSize: widget.isMobile ? 13 : null,
    );
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: AppColors.textPrimary,
      fontWeight: FontWeight.bold,
      fontSize: widget.isMobile ? 14 : null,
    );

    if (widget.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 4),
          Text(value, style: valueStyle),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}
