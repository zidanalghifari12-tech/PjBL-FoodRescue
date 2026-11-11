import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final FeedProduct product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  void _increment() {
    if (quantity < product.maxStockKg) {
      onQuantityChanged(quantity + 1);
    }
  }

  void _decrement() {
    if (quantity > 1) {
      onQuantityChanged(quantity - 1);
    }
  }

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
          // Category Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF065F46),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.category,
              style: const TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Product Name
          Text(
            product.name,
            style: const TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.neutralColor,
            ),
          ),
          const SizedBox(height: 8),

          // Price Row with "Harga Murah" Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${product.price}',
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF047857),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '/Kg',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.badgeText,
                  style: const TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Stock Info Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.hourglass_empty_rounded,
                  size: 18,
                  color: Color(0xFF047857),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Stok Ready',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 10.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${product.stock} (Tersedia)',
                      style: const TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quantity Selector Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.balance_rounded,
                    size: 18,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Jumlah yang diambil',
                    style: TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                  ),
                ],
              ),
              // Stepper: [-] [ 2Kg ] [+]
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    InkWell(
                      onTap: quantity > 1 ? _decrement : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: quantity > 1
                              ? const Color(0xFFEEF2FF)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.remove_rounded,
                          size: 16,
                          color: quantity > 1
                              ? const Color(0xFF475569)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Text(
                        '${quantity}Kg',
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutralColor,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: quantity < product.maxStockKg ? _increment : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: quantity < product.maxStockKg
                              ? const Color(0xFF047857)
                              : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Condition Row: Sortiran Bersih Tanpa Plastik
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  product.condition,
                  style: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

