import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class CheckoutPaymentSummary extends StatelessWidget {
  final int subtotal;
  final int fee;
  final int total;

  const CheckoutPaymentSummary({
    super.key,
    required this.subtotal,
    this.fee = 0,
    required this.total,
  });

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

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
          const Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              fontFamily: AppTheme.headingFontFamily,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.neutralColor,
            ),
          ),
          const SizedBox(height: 12),

          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga Produk',
                style: TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                'Rp ${_formatNumber(subtotal)}',
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.neutralColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Biaya Layanan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Biaya Layanan FoodRescue',
                style: TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                fee == 0 ? 'Gratis' : 'Rp ${_formatNumber(fee)}',
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),

          const Divider(height: 24, color: Color(0xFFF1F5F9)),

          // Total Pembayaran
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Pembayaran',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
              Text(
                'Rp ${_formatNumber(total)}',
                style: const TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 17,
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

