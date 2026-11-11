import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class CartSummaryBar extends StatelessWidget {
  final bool isAllSelected;
  final ValueChanged<bool?> onToggleSelectAll;
  final int totalCost;
  final int selectedCount;
  final VoidCallback onCheckout;

  const CartSummaryBar({
    super.key,
    required this.isAllSelected,
    required this.onToggleSelectAll,
    required this.totalCost,
    required this.selectedCount,
    required this.onCheckout,
  });

  Widget _buildCircularCheckbox() {
    return InkWell(
      onTap: () => onToggleSelectAll(!isAllSelected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isAllSelected ? AppTheme.primaryColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isAllSelected
                ? AppTheme.primaryColor
                : const Color(0xFF94A3B8),
            width: 1.8,
          ),
        ),
        child: isAllSelected
            ? const Icon(
                Icons.check_rounded,
                size: 14,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCount > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Pilih Semua & Total Pesanan
            Row(
              children: [
                _buildCircularCheckbox(),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => onToggleSelectAll(!isAllSelected),
                  child: const Text(
                    'Pilih semua',
                    style: TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Total pesanan ',
                  style: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 11.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  'Rp${_formatNumber(totalCost)}',
                  style: const TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF047857),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: hasSelection ? onCheckout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: const Color(0xFF94A3B8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Checkout Pesanan',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

