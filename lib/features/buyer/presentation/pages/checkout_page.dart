import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/data/cart_manager.dart';
import 'package:foodrescue/features/buyer/models/cart_item_model.dart';
import 'package:foodrescue/features/buyer/models/order_model.dart';
import 'package:foodrescue/features/buyer/presentation/pages/order_confirmation_page.dart';
import 'package:foodrescue/features/history/data/order_manager.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/checkout/checkout_items_card.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/checkout/checkout_payment_summary.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/checkout/checkout_pickup_card.dart';
import 'package:foodrescue/features/buyer/presentation/widgets/checkout/checkout_store_card.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _notesController = TextEditingController();
  String _selectedSchedule = 'Hari ini';
  String _selectedTime = '10:00 WIB';

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleCreateOrder(List<CartItem> selectedItems, int totalCost) {
    if (selectedItems.isEmpty) return;

    final primaryProduct = selectedItems.first.product;

    // Generate unique order number (e.g., #PK-240318 or timestamp-based)
    final orderIdSuffix = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final orderNumber = '#PK-$orderIdSuffix';

    final order = OrderModel(
      orderNumber: orderNumber,
      items: List.from(selectedItems),
      storeName: primaryProduct.sellerName,
      storeAddress: primaryProduct.locationAddress,
      distanceKm: primaryProduct.distanceKm,
      pickupSchedule: _selectedSchedule,
      pickupTime: '$_selectedSchedule, $_selectedTime',
      notes: _notesController.text.trim(),
      subtotal: totalCost,
      fee: 0,
      total: totalCost,
      createdAt: DateTime.now(),
      orderStatus: OrderStatus.pendingConfirmation,
    );

    // Add order to OrderManager for transaction history tracking
    OrderManager().addOrder(order);

    // Remove ordered items from CartManager
    final cartManager = CartManager();
    for (final item in selectedItems) {
      cartManager.removeItem(item.product.id);
    }

    // Navigate to OrderConfirmationPage
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrderConfirmationPage(
          order: order,
          returnToHomeOnBack: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = CartManager();

    return ListenableBuilder(
      listenable: cartManager,
      builder: (context, _) {
        final selectedItems =
            cartManager.items.where((i) => i.isSelected).toList();
        final totalCost = cartManager.selectedTotalCost;

        // Group selected items by store
        final Map<String, List<CartItem>> itemsBySeller = {};
        for (final item in selectedItems) {
          itemsBySeller
              .putIfAbsent(item.product.sellerName, () => [])
              .add(item);
        }

        final primaryProduct = selectedItems.isNotEmpty
            ? selectedItems.first.product
            : null;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.neutralColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Checkout Pesanan',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralColor,
              ),
            ),
            centerTitle: true,
          ),
          body: selectedItems.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.remove_shopping_cart_outlined,
                          size: 64,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Tidak ada barang yang dipilih',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Kembali ke keranjang dan pilih pakan yang ingin Anda checkout.',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Kembali ke Keranjang'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  children: [
                    // 1. Informasi Toko
                    ...itemsBySeller.entries.map((entry) {
                      final storeItems = entry.value;
                      final firstProduct = storeItems.first.product;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckoutStoreCard(
                            storeName: firstProduct.sellerName,
                            storeAddress: firstProduct.locationAddress,
                            distanceKm: firstProduct.distanceKm,
                            isOpen: firstProduct.isOpen,
                          ),
                          const SizedBox(height: 12),

                          // 2. Ringkasan Barang Toko
                          CheckoutItemsCard(items: storeItems),
                          const SizedBox(height: 14),
                        ],
                      );
                    }),

                    // 3. Informasi Pengambilan
                    CheckoutPickupCard(
                      selectedSchedule: _selectedSchedule,
                      selectedTime: _selectedTime,
                      onScheduleChanged: (schedule) {
                        setState(() {
                          _selectedSchedule = schedule;
                        });
                      },
                      onTimeChanged: (time) {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                      pickupAddress: primaryProduct?.locationAddress ??
                          'Caringin, Bandar Lampung',
                      notesController: _notesController,
                    ),
                    const SizedBox(height: 14),

                    // 4. Ringkasan Pembayaran
                    CheckoutPaymentSummary(
                      subtotal: totalCost,
                      fee: 0,
                      total: totalCost,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
          bottomNavigationBar: selectedItems.isEmpty
              ? null
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () =>
                            _handleCreateOrder(selectedItems, totalCost),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF047857),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Buat Pesanan',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
