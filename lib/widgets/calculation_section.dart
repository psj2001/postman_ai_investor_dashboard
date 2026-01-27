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
      text: widget.revenueSharePercent.toStringAsFixed(4),
    );
    _monthsController = TextEditingController(
      text: widget.monthsSinceLaunch.toString(),
    );
    _equityController = TextEditingController(
      text: widget.investorEquityPercent.toStringAsFixed(3),
    );
  }

  @override
  void didUpdateWidget(CalculationSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revenueSharePercent != oldWidget.revenueSharePercent) {
      _revenueShareController.text = widget.revenueSharePercent.toStringAsFixed(
        4,
      );
    }
    if (widget.monthsSinceLaunch != oldWidget.monthsSinceLaunch) {
      _monthsController.text = widget.monthsSinceLaunch.toString();
    }
    if (widget.investorEquityPercent != oldWidget.investorEquityPercent) {
      _equityController.text = widget.investorEquityPercent.toStringAsFixed(3);
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
    final inputBorderRadius = BorderRadius.circular(
      12.0,
    ); // Added border radius constant

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
            border: Border.all(color: AppColors.borderLight, width: 1),
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
                  fontSize: widget.isMobile ? 12 : null,
                  color: AppColors.textPrimary,
                ),
              ),
              // SizedBox(height: pad),
              if (widget.isMobile)
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revenue Share %',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        // const SizedBox(height: 8),
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
                          decoration: InputDecoration(
                            hintText: '1.3333',
                            suffix: Text(
                              '%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            // helperText: 'Range: 0.0001% - 10%',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.white,
                                width: 2.0,
                              ),
                              borderRadius:
                                  inputBorderRadius, // Applied border radius
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.white,
                                width: 2.0,
                              ),
                              borderRadius:
                                  inputBorderRadius, // Applied border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textSecondary,
                                width: 2.5,
                              ),
                              borderRadius:
                                  inputBorderRadius, // Applied border radius
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            final percent = double.tryParse(value) ?? 0.0;
                            final clampedPercent = percent.clamp(0.0001, 10.0);
                            if (clampedPercent != percent) {
                              _revenueShareController.text = clampedPercent
                                  .toStringAsFixed(4);
                            }
                            widget.onRevenueShareChanged(clampedPercent);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Months Since Launch Input with label above
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Months Since Launch',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _monthsController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            hintText: '6',
                            // helperText: 'Range: 1 - 120 months',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.white,
                                width: 2.0,
                              ),
                              borderRadius:
                                  inputBorderRadius, // Applied border radius
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.white,
                                width: 2.0,
                              ),
                              borderRadius:
                                  inputBorderRadius, // Applied border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.textSecondary,
                                width: 2.5,
                              ),
                              borderRadius:
                                  inputBorderRadius, // Applied border radius
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onChanged: (value) {
                            final months = int.tryParse(value) ?? 0;
                            final clampedMonths = months.clamp(1, 120);
                            if (clampedMonths != months) {
                              _monthsController.text = clampedMonths.toString();
                            }
                            widget.onMonthsChanged(clampedMonths);
                          },
                        ),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Revenue Share %',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                            decoration: InputDecoration(
                              hintText: '1.3333',
                              suffixText: '%',
                              // helperText: 'Range: 0.0001% - 10%',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.white,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    inputBorderRadius, // Applied border radius
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.white,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    inputBorderRadius, // Applied border radius
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary,
                                  width: 2.5,
                                ),
                                borderRadius:
                                    inputBorderRadius, // Applied border radius
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (value) {
                              final percent = double.tryParse(value) ?? 0.0;
                              final clampedPercent = percent.clamp(
                                0.0001,
                                10.0,
                              );
                              if (clampedPercent != percent) {
                                _revenueShareController.text = clampedPercent
                                    .toStringAsFixed(4);
                              }
                              widget.onRevenueShareChanged(clampedPercent);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Months Since Launch',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _monthsController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              hintText: '6',
                              // helperText: 'Range: 1 - 120 months',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.white,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    inputBorderRadius, // Applied border radius
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.white,
                                  width: 2.0,
                                ),
                                borderRadius:
                                    inputBorderRadius, // Applied border radius
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.textSecondary,
                                  width: 2.5,
                                ),
                                borderRadius:
                                    inputBorderRadius, // Applied border radius
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (value) {
                              final months = int.tryParse(value) ?? 0;
                              final clampedMonths = months.clamp(1, 120);
                              if (clampedMonths != months) {
                                _monthsController.text = clampedMonths
                                    .toString();
                              }
                              widget.onMonthsChanged(clampedMonths);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: pad),
              Container(
                padding: EdgeInsets.all(widget.isMobile ? 14 : 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                ),
                child: Column(
                  children: [
                    widget.isMobile
                        ? _buildMobileInfoRow(
                            context,
                            'Investor Revenue Pool (20%)',
                            _formatCurrency(_investorRevenuePool),
                          )
                        : _buildInfoRow(
                            context,
                            'Investor Revenue Pool (20%)',
                            _formatCurrency(_investorRevenuePool),
                            isMobile: widget.isMobile,
                          ),
                    SizedBox(height: widget.isMobile ? 10 : 12),
                    widget.isMobile
                        ? _buildMobileInfoRow(
                            context,
                            'Investor Monthly Income',
                            _formatCurrency(_investorMonthlyIncome),
                          )
                        : _buildInfoRow(
                            context,
                            'Investor Monthly Income',
                            _formatCurrency(_investorMonthlyIncome),
                            isMobile: widget.isMobile,
                          ),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    Divider(color: AppColors.white),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: widget.isMobile
                          ? _buildMobileInfoRow(
                              context,
                              'Total Income Till Date',
                              _formatCurrency(_totalIncomeTillDate),
                              isHighlighted: true,
                              key: ValueKey(_totalIncomeTillDate),
                            )
                          : _buildInfoRow(
                              context,
                              'Total Income Till Date',
                              _formatCurrency(_totalIncomeTillDate),
                              isHighlighted: true,
                              isMobile: widget.isMobile,
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
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
            border: Border.all(color: AppColors.borderLight, width: 1),
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
                  color: AppColors.textPrimary,
                ),
              ),
              // SizedBox(height: pad),
              // // Investor Equity Input with label above and yellow outline
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Investor Equity %',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _equityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,4}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: '1.0',
                      suffixText: '%',
                      // helperText: 'Range: 0.001% - 50%',
                      suffixStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.white,
                          width: 2.0,
                        ),
                        borderRadius: inputBorderRadius,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.white,
                          width: 2.0,
                        ),
                        borderRadius: inputBorderRadius,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.textSecondary,
                          width: 2.5,
                        ),
                        borderRadius: inputBorderRadius,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      final percent = double.tryParse(value) ?? 0.0;
                      // Clamp equity percentage between 0.001% and 50%
                      final clampedPercent = percent.clamp(0.001, 50.0);
                      if (clampedPercent != percent) {
                        _equityController.text = clampedPercent.toStringAsFixed(
                          3,
                        );
                      }
                      widget.onEquityPercentChanged(clampedPercent);
                    },
                  ),
                ],
              ),
              SizedBox(height: pad),
              Container(
                padding: EdgeInsets.all(widget.isMobile ? 14 : 20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                ),
                child: Column(
                  children: [
                    widget.isMobile
                        ? _buildMobileInfoRow(
                            context,
                            'Company Valuation',
                            _formatCurrency(_companyValuation),
                          )
                        : _buildInfoRow(
                            context,
                            'Company Valuation',
                            _formatCurrency(_companyValuation),
                            isMobile: widget.isMobile,
                          ),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    Divider(color: AppColors.white),
                    SizedBox(height: widget.isMobile ? 12 : 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: widget.isMobile
                          ? _buildMobileInfoRow(
                              context,
                              'Equity Value',
                              _formatCurrency(_equityValue),
                              isHighlighted: true,
                              key: ValueKey(_equityValue),
                            )
                          : _buildInfoRow(
                              context,
                              'Equity Value',
                              _formatCurrency(_equityValue),
                              isHighlighted: true,
                              isMobile: widget.isMobile,
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
    bool isMobile = false, // Add this parameter
  }) {
    final textStyle = Theme.of(context).textTheme;

    // Define font sizes based on highlight status
    double labelFontSize;
    double valueFontSize;

    if (isHighlighted) {
      labelFontSize = widget.isMobile ? 15 : 18;
      valueFontSize = widget.isMobile ? 20 : 24;
    } else {
      labelFontSize = widget.isMobile ? 13 : 15;
      valueFontSize = widget.isMobile ? 16 : 20;
    }

    final labelStyle = TextStyle(
      color: AppColors.white,
      fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
      fontSize: labelFontSize,
    );

    final valueStyle = TextStyle(
      color: AppColors.white,
      fontWeight: FontWeight.bold,
      fontSize: valueFontSize,
    );

    // Always use Row for both web and mobile
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
        Flexible(
          child: Text(value, style: valueStyle, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}

Widget _buildMobileInfoRow(
  BuildContext context,
  String title,
  String value, {
  bool isHighlighted = false,
  Key? key,
}) {
  return Container(
    key: key,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title section - wraps to next line if needed
        Flexible(
          child: Text(
            title,
            style: isHighlighted
                ? Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
            maxLines: 2, // Allow title to take up to 2 lines
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 4),
        // Value section - wraps to next line if needed
        Flexible(
          child: Text(
            value,
            style: isHighlighted
                ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  )
                : Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
            maxLines: 2, // Allow value to take up to 2 lines
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    ),
  );
}
