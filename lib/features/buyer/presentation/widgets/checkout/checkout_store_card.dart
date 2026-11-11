import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class CheckoutStoreCard extends StatelessWidget {
  final String storeName;
  final String storeAddress;
  final double distanceKm;
  final bool isOpen;

  const CheckoutStoreCard({
    super.key,
    required this.storeName,
    required this.storeAddress,
    required this.distanceKm,
    this.isOpen = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // Store Icon in soft container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Color(0xFF0284C7),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Store details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        storeName,
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutralColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isOpen ? 'Buka' : 'Tutup',
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF047857),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '$storeAddress · ${distanceKm.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

