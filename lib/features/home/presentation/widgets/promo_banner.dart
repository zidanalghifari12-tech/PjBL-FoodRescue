import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class PromoBanner extends StatelessWidget {
  final VoidCallback? onCheckSurplusTap;

  const PromoBanner({
    super.key,
    this.onCheckSurplusTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF059669),
              Color(0xFF047857),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF059669).withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Heading and Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Halo, Peternakan Berkah 🌾',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Dapatkan surplus pakan cepat dari pasar & resto lokal sekitar Bandar Lampung',
                        style: TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 11.5,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Hemat s.d 70%',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bottom Row: Button and Price Highlight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: onCheckSurplusTap ??
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Menampilkan surplus pakan hari ini...'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Cek Surplus Hari Ini',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 15,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Mulai dari',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    RichText(
                      text: const TextSpan(
                        text: 'Rp500',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFA7F3D0),
                        ),
                        children: [
                          TextSpan(
                            text: '/kg',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

