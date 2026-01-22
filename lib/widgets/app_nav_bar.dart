import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Monday.com-style sticky navigation bar with logo.
/// Adapts layout for mobile: compact logo, tighter padding.
class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  static const double _mobileBreakpoint = 600;
  static const double _narrowBreakpoint = 380;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < _mobileBreakpoint;
        final isNarrow = constraints.maxWidth < _narrowBreakpoint;
        final pad = MediaQuery.of(context).padding;
        final containerPadding = isMobile
            ? EdgeInsets.only(
                left: 16 + pad.left,
                right: 16 + pad.right,
                top: 12,
                bottom: 12,
              )
            : EdgeInsets.only(
                left: 24 + pad.left,
                right: 24 + pad.right,
                top: 16,
                bottom: 16,
              );

        return Container(
          padding: containerPadding,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: _buildLogo(context, isMobile, isNarrow),
          ),
        );
      },
    );
  }

  Widget _buildLogo(BuildContext context, bool isMobile, bool isNarrow) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/image.png',
          height: isNarrow ? 24 : (isMobile ? 28 : 36),
          width: isNarrow ? 72 : (isMobile ? 100 : 150),
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        SizedBox(width: isNarrow ? 6 : 8),
        Flexible(
          child: Text(
            isNarrow ? 'Dashboard' : (isMobile ? 'Dashboard' : 'Investor Dashboard'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: isNarrow ? 14 : (isMobile ? 15 : null),
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
