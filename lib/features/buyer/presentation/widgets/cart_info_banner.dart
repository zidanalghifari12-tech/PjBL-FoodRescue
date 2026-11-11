import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class CartInfoBanner extends StatelessWidget {
  const CartInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFDCFCE7)),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.shopping_basket_outlined,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Pilih pesanan untuk melihat detail dan lanjut ke checkout.',
                style: TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 12,
                  color: Color(0xFF334155),
                  height: 1.35,
                ),
              ),
            ),
            SizedBox(width: 6),
            Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF64748B),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

