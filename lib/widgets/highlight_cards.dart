import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Monday.com-style "A leader you can trust" section: 3 horizontal cards
/// with distinct backgrounds (lavender, amber, green).
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
                fontSize: isMobile ? 18 : 24,
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
                      child: _HighlightCard1(isMobile: isMobile)),
                  SizedBox(
                      width: cardWidth,
                      child: _HighlightCard2(isMobile: isMobile)),
                  SizedBox(
                      width: cardWidth,
                      child: _HighlightCard3(isMobile: isMobile)),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _HighlightCard1(isMobile: isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _HighlightCard2(isMobile: isMobile),
                SizedBox(height: isMobile ? 16 : 24),
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
        color: AppColors.cardLavender,
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Revenue pool',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            '20% of total MRR is distributed to investors. '
            'Your share is based on your revenue share percentage.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontSize: isMobile ? 13 : null,
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
        color: AppColors.cardAmber,
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Badge (monday.com G2-style)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
              children: [
                Text(
                  '5× ARR',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontSize: isMobile ? 16 : null,
                      ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  'VALUATION MULTIPLE',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                        fontSize: isMobile ? 10 : null,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 10 : 16),
          Text(
            'Company valuation is based on 5× annual recurring revenue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontSize: isMobile ? 13 : null,
                ),
            textAlign: TextAlign.center,
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
        color: AppColors.cardGreen,
        borderRadius: BorderRadius.circular(AppColors.cardRadiusLarge),
        boxShadow: [AppColors.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Equity value',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            'Your equity share of the company valuation. '
            'It grows as monthly revenue and valuation increase.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                  fontSize: isMobile ? 13 : null,
                ),
          ),
        ],
      ),
    );
  }
}
