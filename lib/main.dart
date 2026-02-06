import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'widgets/app_nav_bar.dart';
import 'widgets/pricing_card.dart';
import 'widgets/summary_card.dart';
import 'widgets/total_users_card.dart';
import 'widgets/calculation_section.dart';
import 'widgets/highlight_cards.dart';
import 'widgets/withdraw_dialog.dart' show WithdrawDialog, showReinvestPrompt;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investor Revenue Dashboard',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const InvestorDashboard(),
    );
  }
}

class InvestorDashboard extends StatefulWidget {
  const InvestorDashboard({super.key});

  @override
  State<InvestorDashboard> createState() => _InvestorDashboardState();
}

class _InvestorDashboardState extends State<InvestorDashboard> {
  // State variables
  int creatorsCount = 0;
  int smesCount = 0;
  int agenciesCount = 0;
  double revenueSharePercent = 1.3333;
  int monthsSinceLaunch = 6;
  double investorEquityPercent = 1.0;

  // Calculated values
  int get totalUsers => creatorsCount + smesCount + agenciesCount;
  double get creatorsRevenue => creatorsCount * 199;
  double get smesRevenue => smesCount * 499;
  double get agenciesRevenue => agenciesCount * 2999;
  double get totalMRR => creatorsRevenue + smesRevenue + agenciesRevenue;

  double get investorRevenuePool => totalMRR * 0.20;
  double get investorMonthlyIncome =>
      investorRevenuePool * (revenueSharePercent / 100);
  double get totalIncomeTillDate => investorMonthlyIncome * monthsSinceLaunch;

  double get companyValuation => totalMRR * 12 * 5;
  double get equityValue => companyValuation * (investorEquityPercent / 100);

  // Total profit amount withdrawn till date (for demo, can be wired to real data)
  double totalProfitWithdrawnTillDate = 0.0;
  double totalReinvestedAmount = 0.0;

  void _showWithdrawDialog() {
    WithdrawDialog.show(
      context,
      revenueSharePercent: revenueSharePercent,
      totalIncomeTillDate: totalIncomeTillDate,
      totalProfitWithdrawnTillDate: totalProfitWithdrawnTillDate,
      totalReinvestedAmount: totalReinvestedAmount,
      equityValue: equityValue,
      onWithdraw: (amount) {
        setState(() => totalProfitWithdrawnTillDate += amount);
      },
      onReinvest: (amount) {
        setState(() {
          totalReinvestedAmount += amount;
        });
      },
    );
  }

  void _reinvestAll() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.cardBackground,
          content: Text(
            'Your income has already been withdrawn or reinvested.',
            style: TextStyle(color: Colors.black),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Monday.com-style sticky nav bar
          const AppNavBar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLargeScreen = constraints.maxWidth >= 1200;
                final isMobile = constraints.maxWidth < 600;
                final horizontalPadding = isLargeScreen
                    ? 80.0
                    : (isMobile ? 16.0 : 24.0);
                final sectionSpacing = isMobile ? 32.0 : 48.0;
                final headingGap = isMobile ? 32.0 : 56.0;
                final blockGap = isMobile ? 20.0 : 24.0;

                final bottomPadding = MediaQuery.of(context).padding.bottom;
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left:
                          horizontalPadding +
                          MediaQuery.of(context).padding.left,
                      right:
                          horizontalPadding +
                          MediaQuery.of(context).padding.right,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: isMobile ? 10 : 38),
                        _buildHeader(isMobile),
                        SizedBox(height: headingGap),
                        _sectionHeading('Pricing & users', isMobile),
                        SizedBox(height: blockGap),
                        _buildPricingSection(isLargeScreen, isMobile),
                        SizedBox(height: sectionSpacing),
                        _sectionHeading('Key metrics', isMobile),
                        SizedBox(height: blockGap),
                        _buildSummarySection(isLargeScreen, isMobile),
                        SizedBox(height: sectionSpacing),
                        CalculationSection(
                          isMobile: isMobile,
                          totalMRR: totalMRR,
                          revenueSharePercent: revenueSharePercent,
                          monthsSinceLaunch: monthsSinceLaunch,
                          investorEquityPercent: investorEquityPercent,
                          onRevenueShareChanged: (value) {
                            setState(() => revenueSharePercent = value);
                          },
                          onMonthsChanged: (value) {
                            setState(() => monthsSinceLaunch = value);
                          },
                          onEquityPercentChanged: (value) {
                            setState(() => investorEquityPercent = value);
                          },
                        ),
                        SizedBox(height: sectionSpacing),
                        const HighlightCards(),
                        SizedBox(height: sectionSpacing),
                        Center(
                          child: SizedBox(
                            width: isLargeScreen ? 500 : double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _showWithdrawDialog,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      size: isMobile ? 18 : 20,
                                    ),
                                    label: Text(
                                      isMobile
                                          ? 'Withdraw'
                                          : 'Withdraw to Bank Account',
                                      style: TextStyle(
                                        fontSize: isMobile ? 15 : 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: isMobile ? 16 : 20,
                                      ),
                                      minimumSize: Size(0, isMobile ? 48 : 52),
                                    ),
                                  ),
                                ),
                                SizedBox(width: isMobile ? 12 : 16),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      final withdrawable =
                                          (totalIncomeTillDate -
                                                  totalProfitWithdrawnTillDate)
                                              .clamp(0.0, double.infinity);
                                      if (withdrawable > 0) {
                                        showReinvestPrompt(
                                          context,
                                          maxAmount: withdrawable,
                                          onReinvest: (amount) {
                                            setState(() {
                                              totalReinvestedAmount += amount;
                                            });
                                          },
                                        );
                                      } else {
                                        _reinvestAll();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.replay,
                                      size: isMobile ? 18 : 20,
                                    ),
                                    label: Text(
                                      'Reinvest',
                                      style: TextStyle(
                                        fontSize: isMobile ? 15 : 16,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        vertical: isMobile ? 16 : 20,
                                      ),
                                      minimumSize: Size(0, isMobile ? 48 : 52),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: (isMobile ? 24 : 60) + bottomPadding),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(String text, bool isMobile) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontSize: isMobile ? 18 : 32,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Investor Revenue Dashboard',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: isMobile ? 22 : 32,
            height: 1.2,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Text(
          'Understand monthly revenue, income distribution, and\ncompany valuation in real time.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
            fontSize: isMobile ? 13 : 16,
            height: 1.45,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection(bool isLargeScreen, bool isMobile) {
    if (isLargeScreen) {
      // 3-column grid for large screens
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PricingCard(
              title: 'Creators',
              icon: 'creator.png',
              pricePerUser: 199,
              userCount: creatorsCount,
              onUserCountChanged: (value) {
                setState(() => creatorsCount = value);
              },
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: PricingCard(
              title: 'SMEs',
              icon: 'sme.png',
              pricePerUser: 499,
              userCount: smesCount,
              onUserCountChanged: (value) {
                setState(() => smesCount = value);
              },
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: PricingCard(
              title: 'Agencies',
              icon: 'agencies.png',
              pricePerUser: 2999,
              userCount: agenciesCount,
              onUserCountChanged: (value) {
                setState(() => agenciesCount = value);
              },
            ),
          ),
        ],
      );
    } else {
      // Single column for smaller screens
      final gap = isMobile ? 16.0 : 24.0;
      return Column(
        children: [
          PricingCard(
            title: 'Creators',
            icon: 'creator.png',
            pricePerUser: 199,
            userCount: creatorsCount,
            onUserCountChanged: (value) {
              setState(() => creatorsCount = value);
            },
          ),
          SizedBox(height: gap),
          PricingCard(
            title: 'SMEs',
            icon: 'sme.png',
            pricePerUser: 499,
            userCount: smesCount,
            onUserCountChanged: (value) {
              setState(() => smesCount = value);
            },
          ),
          SizedBox(height: gap),
          PricingCard(
            title: 'Agencies',
            icon: 'agencies.png',
            pricePerUser: 2999,
            userCount: agenciesCount,
            onUserCountChanged: (value) {
              setState(() => agenciesCount = value);
            },
          ),
        ],
      );
    }
  }

  Widget _buildSummarySection(bool isLargeScreen, bool isMobile) {
    if (isLargeScreen) {
      // Two cards side by side on large screens
      return Row(
        children: [
          Expanded(child: SummaryCard(totalMRR: totalMRR)),
          const SizedBox(width: 24),
          Expanded(child: TotalUsersCard(totalUsers: totalUsers)),
        ],
      );
    } else {
      // Stacked on smaller screens
      return Column(
        children: [
          SummaryCard(totalMRR: totalMRR),
          SizedBox(height: isMobile ? 16 : 24),
          TotalUsersCard(totalUsers: totalUsers),
        ],
      );
    }
  }
}
