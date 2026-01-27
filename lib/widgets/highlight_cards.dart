import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Monday.com-style "Why invest with us" section: 3 horizontal cards
/// with consistent blue background.
class HighlightCards extends StatelessWidget {
  const HighlightCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Why invest with us',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: isMobile ? 18 : 32,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isMobile ? 16 : 32),
        LayoutBuilder(
          builder: (context, constraints) {
            final isLarge = constraints.maxWidth >= 900;
            final isMobile = constraints.maxWidth < 600;
            if (isLarge) {
              final cardWidth = (constraints.maxWidth - 48) / 3;
              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _HighlightCard1(isMobile: isMobile),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _HighlightCard2(isMobile: isMobile),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _HighlightCard3(isMobile: isMobile),
                  ),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HighlightCard1(isMobile: isMobile),
                SizedBox(height: isMobile ? 18 : 26),
                _HighlightCard2(isMobile: isMobile),
                SizedBox(height: isMobile ? 18 : 26),
                _HighlightCard3(isMobile: isMobile),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _HighlightCard1 extends StatelessWidget {
  const _HighlightCard1({this.isMobile = false});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Color(0xFF99AFFB),
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      height: isMobile ? 150 : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Revenue pool',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Expanded(
            child: Text(
              '20% of total MRR is distributed to investors. '
              'Your share is based on your revenue share percentage.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
                fontSize: isMobile ? 16 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightCard2 extends StatelessWidget {
  const _HighlightCard2({this.isMobile = false});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFF99AFFB),
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      height: isMobile ? 150 : 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // White container
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 20,
              vertical: isMobile ? 2 : 3, // 🔽 reduced
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                10,
              ), // optional: slightly tighter
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '5× ARR',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: isMobile ? 18 : 28,
                    height: 1.1, // 🔽 tighter line height
                  ),
                ),
                Text(
                  'Valuation Multiple',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: isMobile ? 13 : 15, // 🔽 slightly smaller
                    height: 1.1, // 🔽 tighter line height
                  ),
                ),
              ],
            ),
          ),

          // 🔹 ONLY 2px gap (as requested)
          const SizedBox(height: 6),

          // Description text
          Text(
            'Company valuation is fundamentally based on the reliable metric of annual recurring revenue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              height: 1.45,
              fontSize: isMobile ? 14 : null,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class _HighlightCard3 extends StatelessWidget {
  const _HighlightCard3({this.isMobile = false});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Color(0xFF99AFFB),
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      height: isMobile ? 150 : 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Equity value',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Expanded(
            child: Text(
              'Your equity share of the company valuation. '
              'It grows as monthly revenue and valuation increase.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
                fontSize: isMobile ? 16 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
