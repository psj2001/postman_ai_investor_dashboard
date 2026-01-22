import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class CalculationSection extends StatefulWidget {
  final double totalMRR;
  final double revenueSharePercent;
  final int monthsSinceLaunch;
  final double investorEquityPercent;
  final ValueChanged<double> onRevenueShareChanged;
  final ValueChanged<int> onMonthsChanged;
  final ValueChanged<double> onEquityPercentChanged;
  final bool isMobile;

  const CalculationSection({
    super.key,
    required this.totalMRR,
    required this.revenueSharePercent,
    required this.monthsSinceLaunch,
    required this.investorEquityPercent,
    required this.onRevenueShareChanged,
    required this.onMonthsChanged,
    required this.onEquityPercentChanged,
    this.isMobile = false,
  });

  @override
  State<CalculationSection> createState() => _CalculationSectionState();
}

class _CalculationSectionState extends State<CalculationSection> {
  late TextEditingController _revenueShareController;
  late TextEditingController _monthsController;
  late TextEditingController _equityController;

  @override
  void initState() {
    super.initState();
    _revenueShareController = TextEditingController(
      text: widget.revenueSharePercent.toString(),
    );
    _monthsController = TextEditingController(
      text: widget.monthsSinceLaunch.toString(),
    );
    _equityController = TextEditingController(
      text: widget.investorEquityPercent.toString(),
    );
  }

  @override
  void didUpdateWidget(CalculationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revenueSharePercent != oldWidget.revenueSharePercent) {
      _revenueShareController.text = widget.revenueSharePercent.toString();
    }
    if (widget.monthsSinceLaunch != oldWidget.monthsSinceLaunch) {
      _monthsController.text = widget.monthsSinceLaunch.toString();
    }
    if (widget.investorEquityPercent != oldWidget.investorEquityPercent) {
      _equityController.text = widget.investorEquityPercent.toString();
    }
  }

  @override
  void dispose() {
    _revenueShareController.dispose();
    _monthsController.dispose();
    _equityController.dispose();
    super.dispose();
  }

  String _formatCurrency(double amount) {
    // Format large numbers with commas for readability
    final formatted = amount.toStringAsFixed(2);
    // Split into integer and decimal parts
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

  double get _investorRevenuePool => widget.totalMRR * 0.20;
  double get _investorMonthlyIncome =>
      _investorRevenuePool * (widget.revenueSharePercent / 100);
  double get _totalIncomeTillDate =>
      _investorMonthlyIncome * widget.monthsSinceLaunch;
  double get _companyValuation => widget.totalMRR * 12 * 5;
  double get _equityValue =>
      _companyValuation * (widget.investorEquityPercent / 100);

  @override
  Widget build(BuildContext context) {
    final pad = widget.isMobile ? 16.0 : 24.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
            boxShadow: [AppColors.softShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Investor Income',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: widget.isMobile ? 17 : null,
                    ),
              ),
              SizedBox(height: widget.isMobile ? 6 : 8),
              Text(
                'Only 20% of total revenue is distributed to investors.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: widget.isMobile ? 11 : null,
                    ),
              ),
              SizedBox(height: pad),
              if (widget.isMobile)
                Column(
                  children: [
                    TextField(
                      controller: _revenueShareController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,4}'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Revenue Share %',
                        hintText: '1.3333',
                        suffixText: '%',
                      ),
                      onChanged: (value) {
                        final percent = double.tryParse(value) ?? 0.0;
                        widget.onRevenueShareChanged(percent);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _monthsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Months Since Launch',
                        hintText: '6',
                      ),
                      onChanged: (value) {
                        final months = int.tryParse(value) ?? 0;
                        widget.onMonthsChanged(months);
                      },
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _revenueShareController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,4}'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Revenue Share %',
                          hintText: '1.3333',
                          suffixText: '%',
                        ),
                        onChanged: (value) {
                          final percent = double.tryParse(value) ?? 0.0;
                          widget.onRevenueShareChanged(percent);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _monthsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Months Since Launch',
                          hintText: '6',
                        ),
                        onChanged: (value) {
                          final months = int.tryParse(value) ?? 0;
                          widget.onMonthsChanged(months);
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(height: pad),
              Container(
                padding: EdgeInsets.all(widget.isMobile ? 14 : 20),
                decoration: BoxDecoration(
                  color: AppColors.sectionBackground,
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      'Investor Revenue Pool (20%)',
                      _formatCurrency(_investorRevenuePool),
                    ),
                    SizedBox(height: widget.isMobile ? 10 : 12),
                    _buildInfoRow(
                      context,
                      'Investor Monthly Income',
                      _formatCurrency(_investorMonthlyIncome),
                    ),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    const Divider(),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _buildInfoRow(
                        context,
                        'Total Income Till Date',
                        _formatCurrency(_totalIncomeTillDate),
                        isHighlighted: true,
                        key: ValueKey(_totalIncomeTillDate),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: widget.isMobile ? 16 : 24),
        Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
            boxShadow: [AppColors.softShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valuation & Equity',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontSize: widget.isMobile ? 17 : null,
                    ),
              ),
              SizedBox(height: widget.isMobile ? 6 : 8),
              Text(
                'Valuation is based on 5× annual recurring revenue.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: widget.isMobile ? 11 : null,
                    ),
              ),
              SizedBox(height: pad),
              TextField(
                controller: _equityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Investor Equity %',
                  hintText: '1.0',
                  suffixText: '%',
                ),
                onChanged: (value) {
                  final percent = double.tryParse(value) ?? 0.0;
                  widget.onEquityPercentChanged(percent);
                },
              ),
              SizedBox(height: pad),
              Container(
                padding: EdgeInsets.all(widget.isMobile ? 14 : 20),
                decoration: BoxDecoration(
                  color: AppColors.sectionBackground,
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      context,
                      'Company Valuation',
                      _formatCurrency(_companyValuation),
                    ),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    const Divider(),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: _buildInfoRow(
                        context,
                        'Equity Value',
                        _formatCurrency(_equityValue),
                        isHighlighted: true,
                        key: ValueKey(_equityValue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
    Key? key,
  }) {
    final textStyle = Theme.of(context).textTheme;
    final labelStyle = textStyle.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
      fontSize: widget.isMobile ? 13 : null,
    );
    final valueStyle = textStyle.titleLarge?.copyWith(
      color: isHighlighted ? AppColors.accent : AppColors.primary,
      fontWeight: FontWeight.bold,
      fontSize: widget.isMobile ? 16 : null,
    );

    if (widget.isMobile) {
      return Column(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: labelStyle),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: valueStyle),
          ),
        ],
      );
    }

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        Text(value, style: valueStyle),
      ],
    );
  }
}
