import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class WithdrawDialog extends StatelessWidget {
  final double revenueSharePercent;
  final double totalIncomeTillDate;
  final double equityValue;
  final double totalProfitWithdrawnTillDate;
  final double totalReinvestedAmount;
  final void Function(double amount)? onWithdraw;
  final void Function(double amount)? onReinvest;

  const WithdrawDialog({
    super.key,
    required this.revenueSharePercent,
    required this.totalIncomeTillDate,
    required this.equityValue,
    this.totalProfitWithdrawnTillDate = 0,
    this.totalReinvestedAmount = 0,
    this.onWithdraw,
    this.onReinvest,
  });

  double get withdrawableAmount =>
      (totalIncomeTillDate -
              totalProfitWithdrawnTillDate -
              totalReinvestedAmount)
          .clamp(0.0, double.infinity);

  static Future<void> show(
    BuildContext context, {
    required double revenueSharePercent,
    required double totalIncomeTillDate,
    required double equityValue,
    double totalProfitWithdrawnTillDate = 0,
    double totalReinvestedAmount = 0,
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
                totalReinvestedAmount: totalReinvestedAmount,
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
          totalReinvestedAmount: totalReinvestedAmount,
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
      totalReinvestedAmount: totalReinvestedAmount,
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
  final double totalReinvestedAmount;
  final double equityValue;
  final bool isMobile;
  final VoidCallback onClose;
  final void Function(double amount)? onWithdraw;
  final void Function(double amount)? onReinvest;

  const _WithdrawBody({
    required this.revenueSharePercent,
    required this.totalProfitWithdrawnTillDate,
    required this.totalIncomeTillDate,
    required this.totalReinvestedAmount,
    required this.equityValue,
    required this.isMobile,
    required this.onClose,
    this.onWithdraw,
    this.onReinvest,
  });

  double get _withdrawableAmount =>
      (totalIncomeTillDate -
              totalProfitWithdrawnTillDate -
              totalReinvestedAmount)
          .clamp(0.0, double.infinity);

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
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: widget.isMobile ? 18 : 20,
          ),
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
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Already Withdrawn',
          _formatCurrency(widget.totalProfitWithdrawnTillDate),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Reinvested Amount Till Date',
          _formatCurrency(widget.totalReinvestedAmount),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Available to Withdraw',
          _formatCurrency(widget._withdrawableAmount),
        ),
        SizedBox(height: widget.isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Equity Value',
          _formatCurrency(widget.equityValue),
        ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
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
              const SizedBox(height: 8),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white,
              //     foregroundColor: AppColors.primary,
              //   ),
              //   onPressed: widget._withdrawableAmount <= 0
              //       ? null
              //       : () => _showReinvestPrompt(context),
              //   child: const Text('Reinvest'),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  void _showReinvestPrompt(BuildContext context) {
    final max = widget._withdrawableAmount;
    showReinvestPrompt(context, maxAmount: max, onReinvest: widget.onReinvest);
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
              Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: widget.isMobile ? 22 : 26,
              ),
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

String _formatCurrencyHelper(double amount) {
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

void showReinvestPrompt(
  BuildContext context, {
  required double maxAmount,
  required void Function(double amount)? onReinvest,
}) {
  ReinvestDialog.show(context, maxAmount: maxAmount, onReinvest: onReinvest);
}

class _ReinvestBody extends StatefulWidget {
  final double maxAmount;
  final bool isMobile;
  final VoidCallback onClose;
  final void Function(double amount)? onReinvest;

  const _ReinvestBody({
    required this.maxAmount,
    required this.isMobile,
    required this.onClose,
    this.onReinvest,
  });

  @override
  State<_ReinvestBody> createState() => _ReinvestBodyState();
}

class _ReinvestBodyState extends State<_ReinvestBody> {
  late TextEditingController _amountController;
  bool _reinvested = false;
  double _amountReinvested = 0;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pad = widget.isMobile ? 16.0 : 24.0;

    if (_reinvested) {
      return _buildSuccessState(context, pad);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reinvest Earnings',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: widget.isMobile ? 18 : 20,
          ),
        ),
        SizedBox(height: pad),
        Text(
          'Max Amount: ${_formatCurrencyHelper(widget.maxAmount)}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: pad),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Amount to Reinvest',
            hintText: '0.00',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
            ),
            prefixText: 'AED ',
          ),
        ),
        SizedBox(height: pad),
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _onReinvestPressed,
                child: const Text('Reinvest'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                ),
                onPressed: widget.onClose,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onReinvestPressed() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0 || amount > widget.maxAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter amount between 0 and ${widget.maxAmount}',
          ),
        ),
      );
      return;
    }
    setState(() {
      _reinvested = true;
      _amountReinvested = amount;
    });
    widget.onReinvest?.call(amount);
  }

  Widget _buildSuccessState(BuildContext context, double pad) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reinvest',
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
              Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: widget.isMobile ? 22 : 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Successfully reinvested.',
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
        if (_amountReinvested > 0) ...[
          SizedBox(height: pad),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount reinvested',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                _formatCurrencyHelper(_amountReinvested),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
}

class ReinvestDialog extends StatelessWidget {
  final double maxAmount;
  final void Function(double amount)? onReinvest;

  const ReinvestDialog({super.key, required this.maxAmount, this.onReinvest});

  static Future<void> show(
    BuildContext context, {
    required double maxAmount,
    void Function(double amount)? onReinvest,
  }) async {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.background,
        builder: (ctx) => SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom:
                  20 +
                  MediaQuery.of(ctx).viewInsets.bottom +
                  MediaQuery.of(ctx).padding.bottom,
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
                _ReinvestBody(
                  maxAmount: maxAmount,
                  isMobile: true,
                  onClose: () => Navigator.of(ctx).pop(),
                  onReinvest: onReinvest,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      await showDialog(
        context: context,
        builder: (ctx) =>
            ReinvestDialog(maxAmount: maxAmount, onReinvest: onReinvest),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final pad = isMobile ? 20.0 : 32.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
      ),
      child: Container(
        padding: EdgeInsets.all(pad),
        constraints: const BoxConstraints(maxWidth: 500),
        child: _ReinvestBody(
          maxAmount: maxAmount,
          isMobile: isMobile,
          onClose: () => Navigator.of(context).pop(),
          onReinvest: onReinvest,
        ),
      ),
    );
  }
}
