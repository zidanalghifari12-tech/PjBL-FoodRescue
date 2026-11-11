import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class SellerInfoSection extends StatelessWidget {
  final FeedProduct product;
  final VoidCallback? onLocationTap;

  const SellerInfoSection({
    super.key,
    required this.product,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Name and Buka Badge
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  color: Color(0xFF4338CA),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  product.sellerName,
                  style: const TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralColor,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  product.isOpen ? 'Buka' : 'Tutup',
                  style: const TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Location Row
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  product.locationAddress,
                  style: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              Text(
                '${product.distanceKm} km dari lokasi Anda',
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Operating Hours Row
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 15,
                color: Color(0xFF64748B),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  product.pickupShift,
                  style: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
              Text(
                product.operatingHours,
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Button: Lokasi Pengambilan
          InkWell(
            onTap: onLocationTap ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Membuka peta lokasi pengambilan di ${product.locationAddress}...',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0E7FF)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.near_me_outlined,
                    size: 16,
                    color: Color(0xFF0369A1),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Lokasi Pengambilan',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0369A1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

