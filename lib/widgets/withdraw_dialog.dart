import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WithdrawDialog extends StatelessWidget {
  final double revenueSharePercent;
  final double totalIncomeTillDate;
  final double equityValue;

  const WithdrawDialog({
    super.key,
    required this.revenueSharePercent,
    required this.totalIncomeTillDate,
    required this.equityValue,
  });

  /// Shows a dialog on larger screens or a bottom sheet on mobile.
  static Future<void> show(
    BuildContext context, {
    required double revenueSharePercent,
    required double totalIncomeTillDate,
    required double equityValue,
  }) async {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
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
                equityValue: equityValue,
                isMobile: true,
                onClose: () => Navigator.of(ctx).pop(),
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
          equityValue: equityValue,
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
      equityValue: equityValue,
      isMobile: isMobile,
      onClose: () => Navigator.of(context).pop(),
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

class _WithdrawBody extends StatelessWidget {
  final double revenueSharePercent;
  final double totalIncomeTillDate;
  final double equityValue;
  final bool isMobile;
  final VoidCallback onClose;

  const _WithdrawBody({
    required this.revenueSharePercent,
    required this.totalIncomeTillDate,
    required this.equityValue,
    required this.isMobile,
    required this.onClose,
  });

  static String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedWithCommas =
        integerPart.replaceAllMapped(regex, (Match m) => '${m[1]},');
    return 'AED $formattedWithCommas${decimalPart.isNotEmpty ? '.$decimalPart' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final pad = isMobile ? 16.0 : 24.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Withdraw to Bank Account',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: isMobile ? 18 : 20,
              ),
        ),
        SizedBox(height: pad),
        _buildInfoRow(
          context,
          'Revenue Share %',
          '${revenueSharePercent.toStringAsFixed(4)}%',
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Total Income Till Date',
          _formatCurrency(totalIncomeTillDate),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        _buildInfoRow(
          context,
          'Equity Value',
          _formatCurrency(equityValue),
        ),
        SizedBox(height: pad),
        const Divider(),
        SizedBox(height: pad),
        Container(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
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
                size: isMobile ? 18 : 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This is a demo dashboard.\n'
                  'No real money, banking, or withdrawals are involved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isMobile ? 11 : null,
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
            onPressed: onClose,
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
          fontSize: isMobile ? 13 : null,
        );
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: isMobile ? 14 : null,
        );

    if (isMobile) {
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
