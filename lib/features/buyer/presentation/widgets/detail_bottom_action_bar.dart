import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class DetailBottomActionBar extends StatelessWidget {
  final FeedProduct product;
  final int quantity;
  final VoidCallback onChatTap;
  final VoidCallback onOrderTap;

  const DetailBottomActionBar({
    super.key,
    required this.product,
    required this.quantity,
    required this.onChatTap,
    required this.onOrderTap,
  });

  @override
  Widget build(BuildContext context) {
    final totalPrice = product.price * quantity;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left: Total Cost Info
            Expanded(
              flex: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TOTAL BIAYA',
                    style: TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 9.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        product.isFree
                            ? 'Gratis'
                            : _formatNumber(totalPrice),
                        style: const TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF047857),
                        ),
                      ),
                      if (!product.isFree) ...[
                        const SizedBox(width: 2),
                        const Text(
                          '/Kg',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$quantity Kg dipilih',
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Right: Chat Toko & Pesan/Ambil Buttons
            Expanded(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Button: Chat Toko
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton.icon(
                      onPressed: onChatTap,
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 15,
                        color: Color(0xFF0369A1),
                      ),
                      label: const Text(
                        'Chat Toko',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFEFF6FF),
                        side: const BorderSide(color: Color(0xFFDBEAFE)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Button: Pesan / Ambil ->
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: onOrderTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047857),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Pesan / Ambil',
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
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

