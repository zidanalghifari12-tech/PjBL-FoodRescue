import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/data/cart_manager.dart';
import 'package:foodrescue/features/buyer/presentation/pages/cart_page.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/detail_bottom_action_bar.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/pickup_guide_section.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/product_gallery_header.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/product_info_section.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/seller_info_section.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';
import 'package:foodrescue/features/home/presentation/widgets/buyer_bottom_navigation_bar.dart';

class ProductDetailPage extends StatefulWidget {
  final FeedProduct product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 1;
  final int _currentBottomNavIndex = 1; // Highlight 'Pesanan Saya' or matching context

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tautan pakan "${widget.product.name}" berhasil disalin!',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleChatStore() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: AppTheme.primaryColor,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Chat dengan ${widget.product.sellerName}',
                  style: const TextStyle(
                    fontFamily: AppTheme.headingFontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.neutralColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Tanyakan ketersediaan, kondisi pakan terkini, atau koordinasikan penjemputan langsung di ${widget.product.locationAddress}.',
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Simulasi: Terhubung ke ruang obrolan toko!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Mulai Percakapan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOrder() {
    if (_quantity > widget.product.maxStockKg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Jumlah melebihi stok yang tersedia (${widget.product.maxStockKg} kg)!',
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final totalCost = widget.product.price * _quantity;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Pengambilan',
          style: TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Produk: ${widget.product.name}',
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Jumlah: $_quantity Kg',
              style: const TextStyle(fontFamily: AppTheme.bodyFontFamily),
            ),
            Text(
              'Total Biaya: ${widget.product.isFree ? "Gratis" : "Rp$totalCost"}',
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Lokasi: ${widget.product.sellerName} (${widget.product.locationAddress})',
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              CartManager().addItem(widget.product, _quantity);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${widget.product.name} ($_quantity Kg) berhasil ditambahkan ke keranjang!',
                  ),
                  backgroundColor: AppTheme.primaryColor,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppTheme.neutralColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Pesanan',
          style: TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.neutralColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share_outlined,
              color: AppTheme.neutralColor,
            ),
            onPressed: _handleShare,
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable Body Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Galeri Foto Header
                  ProductGalleryHeader(product: widget.product),
                  const SizedBox(height: 12),

                  // Cards Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        // 2. Informasi Produk Card
                        ProductInfoSection(
                          product: widget.product,
                          quantity: _quantity,
                          onQuantityChanged: (qty) {
                            setState(() {
                              _quantity = qty;
                            });
                          },
                        ),
                        const SizedBox(height: 12),

                        // 3. Informasi Penjual Card
                        SellerInfoSection(product: widget.product),
                        const SizedBox(height: 16),

                        // 4. Panduan & Opsi Pengambilan
                        const PickupGuideSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 5. Sticky Bottom Action Bar
          DetailBottomActionBar(
            product: widget.product,
            quantity: _quantity,
            onChatTap: _handleChatStore,
            onOrderTap: _handleOrder,
          ),
        ],
      ),

      // 6. Bottom Navigation Bar
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pop();
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartPage(),
              ),
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => BuyerHomeScreen(initialTabIndex: index),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }
}

