import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool? isStoreSelected;
  final ValueChanged<bool?> onToggleSelection;
  final ValueChanged<bool?>? onToggleStoreSelection;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onViewDetail;
  final VoidCallback? onDelete;

  const CartItemCard({
    super.key,
    required this.item,
    this.isStoreSelected,
    required this.onToggleSelection,
    this.onToggleStoreSelection,
    required this.onQuantityChanged,
    required this.onViewDetail,
    this.onDelete,
  });

  Widget _buildCircularCheckbox({
    required bool isChecked,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!isChecked),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isChecked ? AppTheme.primaryColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isChecked
                ? AppTheme.primaryColor
                : const Color(0xFF94A3B8),
            width: 1.8,
          ),
        ),
        child: isChecked
            ? const Icon(
                Icons.check_rounded,
                size: 14,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = item.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Header Row
            Row(
              children: [
                _buildCircularCheckbox(
                  isChecked: isStoreSelected ?? item.isSelected,
                  onChanged: onToggleStoreSelection ?? onToggleSelection,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.storefront_outlined,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    product.sellerName,
                    style: const TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.neutralColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.isOpen ? 'Buka' : 'Tutup',
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
            const SizedBox(height: 12),

            // Item Content Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCircularCheckbox(
                  isChecked: item.isSelected,
                  onChanged: onToggleSelection,
                ),
                const SizedBox(width: 10),

                // Product Placeholder Photo
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: product.placeholderColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    product.placeholderIcon,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),

                // Name, Info, Price, and Stepper
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
                        'Rp${_formatNumber(product.price)} ${product.priceUnit} · ${product.stock}',
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Price and Stepper Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.isFree
                                ? 'Gratis'
                                : 'Rp${_formatNumber(item.totalPrice)}',
                            style: const TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF047857),
                            ),
                          ),

                          // Quantity Stepper
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: item.quantity > 1
                                      ? () => onQuantityChanged(item.quantity - 1)
                                      : null,
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.remove_rounded,
                                      size: 15,
                                      color: item.quantity > 1
                                          ? const Color(0xFF475569)
                                          : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    item.quantity == 1 && product.priceUnit == '/Sisir'
                                        ? '1'
                                        : '${item.quantity} kg',
                                    style: const TextStyle(
                                      fontFamily: AppTheme.bodyFontFamily,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.neutralColor,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: item.quantity < product.maxStockKg
                                      ? () => onQuantityChanged(item.quantity + 1)
                                      : null,
                                  borderRadius: BorderRadius.circular(6),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.add_rounded,
                                      size: 15,
                                      color: item.quantity < product.maxStockKg
                                          ? AppTheme.primaryColor
                                          : const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Link: Lihat detail pesanan >
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onViewDetail,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 2.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Lihat detail pesanan',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF047857),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 15,
                        color: Color(0xFF047857),
                      ),
                    ],
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
