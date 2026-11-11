import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class BuyerBottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BuyerBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class BuyerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BuyerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BuyerBottomNavItem> items = [
    BuyerBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Beranda',
    ),
    BuyerBottomNavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      label: 'Pesanan Saya',
    ),
    BuyerBottomNavItem(
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Chat',
    ),
    BuyerBottomNavItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Riwayat',
    ),
    BuyerBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Akun Saya',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = currentIndex == index;
              final color = isSelected
                  ? const Color(0xFF047857)
                  : const Color(0xFF475569);

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onTap(index),
                    splashColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    highlightColor: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSelected ? item.activeIcon : item.icon,
                            color: color,
                            size: 22,
                          ),
                          const SizedBox(height: 3),
                          SizedBox(
                            width: 60,
                            child: Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: isSelected
                                    ? AppTheme.headingFontFamily
                                    : AppTheme.bodyFontFamily,
                                fontSize: 10,
                                height: 1.15,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

