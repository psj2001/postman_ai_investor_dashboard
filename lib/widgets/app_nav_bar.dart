import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64, // keep navbar height unchanged
      decoration: BoxDecoration(
        color: const Color(0xFF99AFFB),
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            height: 44, // controls how tall the logo is inside navbar
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fitHeight, // 🔥 fills vertically
            ),
          ),
        ),
      ),
    );
  }
}
