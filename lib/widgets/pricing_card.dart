import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class PricingCard extends StatefulWidget {
  final String title;
  final double pricePerUser;
  final int userCount;
  final ValueChanged<int> onUserCountChanged;

  const PricingCard({
    super.key,
    required this.title,
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

  // Note: We don't sync controller in didUpdateWidget because all changes
  // come from user input via onChanged. The controller maintains its own state.

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

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final pad = isMobile ? 16.0 : 24.0;
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
            boxShadow: [
              AppColors.softShadow,
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatCurrency(widget.pricePerUser)} / user / month',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              SizedBox(height: pad),
              TextField(
                key: ValueKey('${widget.title}_input'),
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Number of Users',
                  hintText: 'Enter number of users',
                  helperText: isMobile ? null : 'Enter any number (e.g., 1000000)',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 14 : 16,
                    vertical: isMobile ? 14 : 16,
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    widget.onUserCountChanged(0);
                    return;
                  }
                  // Handle very large numbers - int can handle up to 2^63-1
                  final count = int.tryParse(value) ?? 0;
                  widget.onUserCountChanged(count);
                },
              ),
              SizedBox(height: pad),
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
                    AnimatedSwitcher(
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
                      child: Text(
                        _formatCurrency(_monthlyRevenue),
                        key: ValueKey(_monthlyRevenue),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
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
