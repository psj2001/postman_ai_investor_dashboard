import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class PricingCard extends StatefulWidget {
  final String title;
  final String icon;
  final double pricePerUser;
  final int userCount;
  final ValueChanged<int> onUserCountChanged;

  const PricingCard({
    super.key,
    required this.title,
    required this.icon,
    required this.pricePerUser,
    required this.userCount,
    required this.onUserCountChanged,
  });

  @override
  State<PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  late TextEditingController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userCount.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _monthlyRevenue => widget.userCount * widget.pricePerUser;

  String _formatCurrency(double amount) {
    // Format large numbers with commas for readability
    final formatted = amount.toStringAsFixed(0);
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedWithCommas = formatted.replaceAllMapped(
      regex,
      (Match m) => '${m[1]},',
    );
    return 'AED $formattedWithCommas';
  }

  // Helper function to determine font size based on number of digits
  double _getMonthlyRevenueFontSize(String formattedValue, bool isMobile) {
    // Remove "AED " prefix and commas to count only digits
    final digitsOnly = formattedValue.replaceAll(RegExp(r'[^0-9]'), '');
    final digitCount = digitsOnly.length;

    if (isMobile) {
      // Mobile font sizes
      if (digitCount >= 10) {
        return 16.0; // Minimum 16 for mobile
      } else if (digitCount >= 8) {
        return 18.0; // 8-9 digits
      } else {
        return 20.0; // 7 or fewer digits
      }
    } else {
      // Web font sizes
      if (digitCount >= 10) {
        return 24.0; // Minimum 24 for web
      } else if (digitCount >= 8) {
        return 26.0; // 8-9 digits
      } else {
        return 28.0; // 7 or fewer digits
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final pad = isMobile ? 16.0 : 24.0;
    final formattedRevenue = _formatCurrency(_monthlyRevenue);
    final revenueFontSize = _getMonthlyRevenueFontSize(
      formattedRevenue,
      isMobile,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(isMobile ? 1.0 : (_isHovered ? 1.02 : 1.0)),
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
            boxShadow: [AppColors.softShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with 30/70 split
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 30% area - White square with dollar icon
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.white, width: 1),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/${widget.icon}',
                      color: AppColors.textPrimary,
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),

                        // Price per user
                        Text(
                          '${_formatCurrency(widget.pricePerUser)} / user / month',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Number of Users',
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),

              // Input field section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    key: ValueKey('${widget.title}_input'),
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLength: 12,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter number of users',
                      helperText: isMobile
                          ? null
                          : 'Enter any number (Eg,1000000)',
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 14 : 16,
                        vertical: isMobile ? 14 : 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.textSecondary,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        widget.onUserCountChanged(0);
                        return;
                      }
                      final count = int.tryParse(value) ?? 0;
                      widget.onUserCountChanged(count);
                    },
                  ),
                ],
              ),

              SizedBox(height: pad),

              // Monthly Revenue section
              Container(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: AppColors.sectionBackground,
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Revenue',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          key: ValueKey(_monthlyRevenue),
                          padding: EdgeInsets.only(left: 8),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerRight,
                            child: Text(
                              formattedRevenue,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: revenueFontSize,
                                  ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
