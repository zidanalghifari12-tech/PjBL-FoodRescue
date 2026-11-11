import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';
import 'package:foodrescue/features/home/presentation/widgets/product_card.dart';

class ProductGridSection extends StatelessWidget {
  final List<FeedProduct> products;
  final ValueChanged<FeedProduct>? onFavoriteToggle;
  final ValueChanged<FeedProduct>? onDetailTap;
  final VoidCallback? onFilterRadiusTap;
  final VoidCallback? onResetFilter;
  final String activeRadiusLabel;

  const ProductGridSection({
    super.key,
    required this.products,
    this.onFavoriteToggle,
    this.onDetailTap,
    this.onFilterRadiusTap,
    this.onResetFilter,
    this.activeRadiusLabel = 'Filter Radius',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Rekomendasi Terdekat',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Pakan Ternak siap angkut hari ini',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: onFilterRadiusTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activeRadiusLabel,
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Grid of Products or Empty State
          if (products.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_off_rounded,
                      size: 36,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak ada pakan yang cocok',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Coba ubah kata kunci atau sesuaikan filter radius & kategori.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  if (onResetFilter != null) ...[
                    const SizedBox(height: 14),
                    OutlinedButton(
                      onPressed: onResetFilter,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Reset Filter',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.61,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  onFavoriteToggle: () => onFavoriteToggle?.call(product),
                  onDetailTap: () => onDetailTap?.call(product),
                );
              },
            ),
        ],
      ),
    );
  }
}

