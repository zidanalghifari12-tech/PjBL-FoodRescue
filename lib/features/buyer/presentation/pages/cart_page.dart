import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/data/cart_manager.dart';
import 'package:foodrescue/features/buyer/presentation/pages/checkout_page.dart';
import 'package:foodrescue/features/buyer/presentation/pages/product_detail_page.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/cart_info_banner.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/cart_item_card.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/cart_summary_bar.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';
import 'package:foodrescue/features/home/presentation/widgets/buyer_bottom_navigation_bar.dart';
import 'package:foodrescue/features/home/presentation/widgets/home_header.dart';

class CartPage extends StatefulWidget {
  final bool showBottomNav;
  final VoidCallback? onNavigateToHome;

  const CartPage({
    super.key,
    this.showBottomNav = true,
    this.onNavigateToHome,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartManager _cartManager = CartManager();
  int _currentTabIndex = 1; // "Pesanan Saya" is active

  void _goToHome() {
    if (widget.onNavigateToHome != null) {
      widget.onNavigateToHome!();
    } else if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const BuyerHomeScreen()),
        (route) => false,
      );
    }
  }

  void _onBottomNavTapped(int index) {
    if (index == 0) {
      _goToHome();
    } else if (index == 1) {
      // Already on Cart / Pesanan Saya
      setState(() {
        _currentTabIndex = 1;
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => BuyerHomeScreen(initialTabIndex: index),
        ),
        (route) => false,
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_cart_outlined,
                size: 42,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Keranjang Pesanan Kosong',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Belum ada pakan surplus yang Anda pilih. Cari dan selamatkan pakan berkualitas sekarang!',
              style: TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12.5,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Cari Pakan Sekarang',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _cartManager,
          builder: (context, _) {
            final items = _cartManager.items;

            return Column(
              children: [
                // Header Konsisten dengan Beranda
                HomeHeader(
                  onLocationTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lokasi keranjang: Bandar Lampung'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),

                // Info Banner
                const CartInfoBanner(),

                // List Items
                Expanded(
                  child: items.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 4, bottom: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return CartItemCard(
                              key: ValueKey(item.product.id),
                              item: item,
                              isStoreSelected: _cartManager.isStoreSelected(
                                item.product.sellerName,
                              ),
                              onToggleStoreSelection: (isSelected) {
                                _cartManager.toggleStoreSelection(
                                  item.product.sellerName,
                                  isSelected ?? false,
                                );
                              },
                              onToggleSelection: (isSelected) {
                                _cartManager.toggleItemSelection(
                                  item.product.id,
                                  isSelected,
                                );
                              },
                              onQuantityChanged: (newQty) {
                                _cartManager.updateQuantity(
                                  item.product.id,
                                  newQty,
                                );
                              },
                              onViewDetail: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailPage(
                                      product: item.product,
                                    ),
                                  ),
                                );
                              },
                              onDelete: () {
                                _cartManager.removeItem(item.product.id);
                              },
                            );
                          },
                        ),
                ),

                // Sticky Summary & Checkout Bar
                CartSummaryBar(
                  isAllSelected: _cartManager.isAllSelected,
                  onToggleSelectAll: (val) {
                    _cartManager.toggleSelectAll(val ?? false);
                  },
                  totalCost: _cartManager.selectedTotalCost,
                  selectedCount: _cartManager.selectedItemCount,
                  onCheckout: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CheckoutPage(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BuyerBottomNavBar(
              currentIndex: _currentTabIndex,
              onTap: _onBottomNavTapped,
            )
          : null,
    );
  }
}

