import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class PickupGuideSection extends StatelessWidget {
  const PickupGuideSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Panduan & Opsi Pengambilan',
          style: TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralColor,
          ),
        ),
        const SizedBox(height: 12),

        // Card 1: Akses Kendaraan Terbuka
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  size: 20,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Akses Kendaraan Terbuka',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Dapat diakses Pickup Bak Terbuka, Tossa Roda Tiga, atau motor bertroli. Akses bongkar muat pasar luas.',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Card 2: Bawa Wadah / Karung Sendiri
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 20,
                  color: Color(0xFF0284C7),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Bawa Wadah / Karung Sendiri',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Keranjang sayur milik pasar wajib dipindahkan ke karung/terpal atau bak pikap Anda di tempat.',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

