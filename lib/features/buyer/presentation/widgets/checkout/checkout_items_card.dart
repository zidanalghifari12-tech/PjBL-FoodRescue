import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/models/cart_item_model.dart';

class CheckoutItemsCard extends StatelessWidget {
  final List<CartItem> items;

  const CheckoutItemsCard({
    super.key,
    required this.items,
  });

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  int get _totalCost => items.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Barang pesanan',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
              Text(
                '${items.length} barang',
                style: const TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 12,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items List
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final product = item.product;

            return Container(
              margin: EdgeInsets.only(bottom: index < items.length - 1 ? 10 : 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  // Product icon container
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: product.placeholderColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      product.placeholderIcon,
                      color: AppTheme.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${product.price} ${product.priceUnit} x ${item.quantity} ${product.priceUnit == '/Sisir' ? 'Sisir' : 'Kg'}',
                          style: const TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Subtotal
                  Text(
                    product.isFree
                        ? 'Gratis'
                        : 'Rp ${_formatNumber(item.totalPrice)}',
                    style: const TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF047857),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Total biaya row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total biaya',
                style: TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 13,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                'Rp ${_formatNumber(_totalCost)}',
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF047857),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

