import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLocationTap;

  const HomeHeader({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          // Logo FoodRescue
          Image.asset(
            'assets/images/food_rescue.png',
            height: 38,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),

          // Area Pakan Pill Selector
          InkWell(
            onTap: onLocationTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lokasi saat ini: Bandar Lampung'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'AREA PAKAN',
                        style: TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF94A3B8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Bandar Lampung',
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neutralColor,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 15,
                            color: Color(0xFF64748B),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),

          // Notification Bell with Red Dot
          InkWell(
            onTap: onNotificationTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anda memiliki 1 notifikasi surplus pakan baru!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    color: AppTheme.neutralColor,
                    size: 24,
                  ),
                  Positioned(
                    top: 1,
                    right: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // User Avatar
          GestureDetector(
            onTap: onProfileTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil Peternakan Berkah'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFEF3C7),
                border: Border.all(
                  color: const Color(0xFFD1FAE5),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF047857),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

