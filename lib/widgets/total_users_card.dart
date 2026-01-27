import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TotalUsersCard extends StatelessWidget {
  final int totalUsers;

  const TotalUsersCard({super.key, required this.totalUsers});

  String _formatNumber(int number) {
    // Format large numbers with commas for readability
    final formatted = number.toString();
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedWithCommas = formatted.replaceAllMapped(
      regex,
      (Match m) => '${m[1]},',
    );
    return formattedWithCommas;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final pad = isMobile ? 18.0 : 32.0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Total Users',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontSize: isMobile ? 13 : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: 0.8 + (0.2 * value),
                        child: child,
                      ),
                    );
                  },
                  child: child,
                );
              },
              child: Text(
                _formatNumber(totalUsers),
                key: ValueKey(totalUsers),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 24 : 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
