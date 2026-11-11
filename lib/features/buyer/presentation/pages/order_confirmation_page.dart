import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/models/order_model.dart';
import 'package:foodrescue/features/chat/presentation/pages/store_chat_page.dart';
import 'package:foodrescue/features/history/data/order_manager.dart';
import 'package:foodrescue/features/history/presentation/pages/order_qr_page.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';

class OrderConfirmationPage extends StatefulWidget {
  final OrderModel order;
  final bool returnToHomeOnBack;

  const OrderConfirmationPage({
    super.key,
    required this.order,
    this.returnToHomeOnBack = false,
  });

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  late OrderModel _currentOrder;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _copyOrderNumber(BuildContext context, String orderNumber) {
    Clipboard.setData(ClipboardData(text: orderNumber));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nomor pesanan $orderNumber berhasil disalin!'),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmCancelOrder(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Batalkan Pesanan?',
          style: TextStyle(
            fontFamily: AppTheme.headingFontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pesanan ${order.orderNumber}? Aksi ini tidak dapat diurungkan.',
          style: const TextStyle(
            fontFamily: AppTheme.bodyFontFamily,
            fontSize: 13,
            color: Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Kembali',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final success = OrderManager().cancelOrder(order.orderNumber);
              if (success) {
                setState(() {
                  _currentOrder = _currentOrder.copyWith(
                    orderStatus: OrderStatus.cancelled,
                  );
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pesanan ${order.orderNumber} berhasil dibatalkan.',
                    ),
                    backgroundColor: const Color(0xFFDC2626),
                    duration: const Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Ya, Batalkan Pesanan',
              style: TextStyle(fontFamily: AppTheme.headingFontFamily),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusHeading(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingConfirmation:
        return 'Menunggu Konfirmasi';
      case OrderStatus.processing:
        return 'Pesanan Diproses';
      case OrderStatus.readyForPickup:
        return 'Siap Diambil';
      case OrderStatus.completed:
        return 'Pesanan Selesai';
      case OrderStatus.cancelled:
        return 'Pesanan Dibatalkan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrderManager(),
      builder: (context, _) {
        final currentOrder =
            OrderManager().getOrder(widget.order.orderNumber) ?? _currentOrder;
        final canCancel = currentOrder.canBeCancelled;
        final isQrActive = currentOrder.isQrActive;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.neutralColor),
              onPressed: () {
                if (widget.returnToHomeOnBack) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const BuyerHomeScreen(),
                    ),
                    (route) => false,
                  );
                } else if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const BuyerHomeScreen(initialTabIndex: 3),
                    ),
                    (route) => false,
                  );
                }
              },
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
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppTheme.neutralColor,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pilihan lainnya'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // 1. Status Pesanan Card (Matching Screenshot 2 & Updated Status Specs)
              Container(
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
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: currentOrder.statusBgColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            currentOrder.statusIcon,
                            color: currentOrder.statusColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _getStatusHeading(currentOrder.orderStatus),
                            style: const TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neutralColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: currentOrder.statusBgColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            currentOrder.statusBadge,
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: currentOrder.statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentOrder.statusDescription,
                      style: const TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nomor pesanan',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              _copyOrderNumber(context, currentOrder.orderNumber),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  currentOrder.orderNumber,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.neutralColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.copy_rounded,
                                  size: 15,
                                  color: Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Toko Card (Matching Screenshot 2)
              Container(
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
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: Color(0xFF047857),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentOrder.storeName,
                            style: const TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neutralColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${currentOrder.storeAddress} · ${currentOrder.distanceKm.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Barang Pesanan Card (Matching Screenshot 2)
              Container(
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
                          '${currentOrder.items.isNotEmpty ? currentOrder.items.length : 1} barang',
                          style: const TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (currentOrder.items.isNotEmpty)
                      ...currentOrder.items.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: item.product.placeholderColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  item.product.placeholderIcon,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(
                                        fontFamily: AppTheme.headingFontFamily,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.neutralColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${item.product.price} ${item.product.priceUnit} x ${item.quantity} ${item.product.priceUnit == '/Sisir' ? 'Sisir' : 'Kg'}',
                                      style: const TextStyle(
                                        fontFamily: AppTheme.bodyFontFamily,
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Rp ${_formatNumber(item.totalPrice)}',
                                style: const TextStyle(
                                  fontFamily: AppTheme.headingFontFamily,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.neutralColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                    else
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: currentOrder.displayIconBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                currentOrder.displayIcon,
                                color: currentOrder.displayIconColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentOrder.primaryProductName,
                                    style: const TextStyle(
                                      fontFamily: AppTheme.headingFontFamily,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.neutralColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${currentOrder.displayPriceUnit ?? "Rp 500 /Kg"} x ${currentOrder.primaryQuantity}',
                                    style: const TextStyle(
                                      fontFamily: AppTheme.bodyFontFamily,
                                      fontSize: 11,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp ${_formatNumber(currentOrder.total)}',
                              style: const TextStyle(
                                fontFamily: AppTheme.headingFontFamily,
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.neutralColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total biaya',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 12.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          'Rp ${_formatNumber(currentOrder.total)}',
                          style: const TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. Informasi Pengambilan Card (Matching Screenshot 2)
              Container(
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
                      'Informasi pengambilan',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.access_time_rounded,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Waktu pengambilan',
                                  style: TextStyle(
                                    fontFamily: AppTheme.bodyFontFamily,
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  currentOrder.pickupTime,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.neutralColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (currentOrder.notes.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Catatan: "${currentOrder.notes}"',
                        style: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 11.5,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Bawa wadah sendiri dan tunjukkan nomor pesanan saat tiba.',
                            style: TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Button 1: Chat Toko (Always Available)
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StoreChatPage(
                              storeName: currentOrder.storeName,
                              storeLocation: currentOrder.storeAddress,
                              order: currentOrder,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.chat_outlined,
                        size: 18,
                        color: Color(0xFF047857),
                      ),
                      label: const Text(
                        'Chat Toko',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF047857),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF0FDF4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                          side: const BorderSide(color: Color(0xFFDCFCE7)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Button 2: Lihat QR Pesanan (Active when readyForPickup, informative when pending/processing)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderQrPage(order: currentOrder),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isQrActive
                            ? const Color(0xFF047857)
                            : const Color(0xFF0F766E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Lihat QR Pesanan',
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isQrActive
                                ? Icons.arrow_forward_rounded
                                : Icons.qr_code_2_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Button 3: Batalkan Pesanan (Available for pendingConfirmation & processing, hidden otherwise)
                  if (canCancel) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _confirmCancelOrder(context, currentOrder),
                        icon: const Icon(
                          Icons.cancel_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Batalkan Pesanan',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
