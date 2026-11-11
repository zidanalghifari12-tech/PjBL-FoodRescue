import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class AppLogoHeader extends StatelessWidget {
  final double logoHeight;
  final double spacingAfterLogo;
  final double spacingAfterTagline;

  const AppLogoHeader({
    super.key,
    this.logoHeight = 60,
    this.spacingAfterLogo = 8,
    this.spacingAfterTagline = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            'assets/images/food_rescue.png',
            height: logoHeight,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: spacingAfterLogo),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Misi Pangan Berkelanjutan',
                  style: TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: spacingAfterTagline),
      ],
    );
  }
}

