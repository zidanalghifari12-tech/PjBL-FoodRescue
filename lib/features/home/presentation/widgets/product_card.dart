import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class ProductCard extends StatelessWidget {
  final FeedProduct product;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDetailTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onFavoriteToggle,
    this.onDetailTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = product.status == 'Tersedia';

    return InkWell(
      onTap: onDetailTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with Badges
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 110,
              width: double.infinity,
              color: product.placeholderColor,
              child: Stack(
                children: [
                  // Center Placeholder Illustration/Icon
                  Center(
                    child: Icon(
                      product.placeholderIcon,
                      size: 48,
                      color: AppTheme.primaryColor.withValues(alpha: 0.45),
                    ),
                  ),

                  // Top Left: Status Badge (Tersedia / Segera)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? AppTheme.primaryColor
                            : const Color(0xFFD97706),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.status,
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Top Right: Favorite Button
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: onFavoriteToggle,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color: product.isFavorite
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Left: Distance Badge
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2.5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.near_me_rounded,
                            size: 11,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${product.distanceKm} km',
                            style: const TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Seller Name
          Text(
            product.sellerName,
            style: const TextStyle(
              fontFamily: AppTheme.bodyFontFamily,
              fontSize: 11,
              color: Color(0xFF64748B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),

          // Product Name
          SizedBox(
            height: 36,
            child: Text(
              product.name,
              style: const TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralColor,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),

          // Stock Info
          Row(
            children: [
              const Icon(
                Icons.hourglass_empty_rounded,
                size: 12,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Stok: ${product.stock}',
                  style: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Price
          Text(
            product.isFree
                ? 'Gratis'
                : 'Rp${_formatNumber(product.price)}${product.priceUnit}',
            style: const TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 14.5,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),

          // Button: Lihat Detail
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: onDetailTap ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Melihat detail: ${product.name}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF047857),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}

