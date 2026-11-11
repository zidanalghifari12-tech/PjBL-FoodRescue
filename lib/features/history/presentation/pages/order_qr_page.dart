import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/models/order_model.dart';
import 'package:foodrescue/features/chat/presentation/pages/store_chat_page.dart';
import 'package:foodrescue/features/history/data/order_manager.dart';
import 'package:foodrescue/features/history/presentation/widgets/dynamic_qr_code.dart';

class OrderQrPage extends StatelessWidget {
  final OrderModel order;

  const OrderQrPage({
    super.key,
    required this.order,
  });

  void _copyOrderCode(BuildContext context, String orderNumber) {
    final cleanCode = orderNumber.replaceAll('#', '');
    Clipboard.setData(ClipboardData(text: cleanCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kode pengambilan $cleanCode berhasil disalin!'),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDirectionDialog(BuildContext context, OrderModel currentOrder) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.directions_outlined, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text(
              'Petunjuk Arah',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentOrder.storeName,
              style: const TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.neutralColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currentOrder.storeAddress,
              style: const TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12.5,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFDCFCE7)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.near_me_outlined,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Jarak: ${currentOrder.distanceKm.toStringAsFixed(1)} km dari lokasi peternakan Anda.',
                      style: const TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12,
                        color: Color(0xFF047857),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: OrderManager(),
      builder: (context, _) {
        final currentOrder =
            OrderManager().getOrder(order.orderNumber) ?? order;
        final cleanCode = currentOrder.orderNumber.replaceAll('#', '');
        final isQrActive = currentOrder.isQrActive;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.neutralColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'QR Pesanan',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralColor,
              ),
            ),
            centerTitle: true,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            children: [
              // 1. Reminder Banner (Matching Screenshot 3 & status)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isQrActive
                      ? const Color(0xFFEFF6FF)
                      : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                          ? const Color(0xFFFEF3C7)
                          : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isQrActive
                        ? const Color(0xFFDBEAFE)
                        : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                            ? const Color(0xFFFDE68A)
                            : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isQrActive
                            ? Icons.access_time_rounded
                            : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                ? Icons.hourglass_top_rounded
                                : Icons.info_outline_rounded),
                        color: isQrActive
                            ? const Color(0xFF047857)
                            : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                ? const Color(0xFFD97706)
                                : const Color(0xFF0284C7)),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isQrActive
                                ? 'Jangan lupa ambil pesananmu'
                                : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                    ? 'Menunggu Konfirmasi Toko'
                                    : (currentOrder.orderStatus == OrderStatus.processing
                                        ? 'Pesanan Sedang Disiapkan'
                                        : currentOrder.status)),
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isQrActive
                                  ? const Color(0xFF0F172A)
                                  : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                      ? const Color(0xFF92400E)
                                      : const Color(0xFF0F172A)),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isQrActive
                                ? 'Tunjukkan kode pengambilan kepada penjual saat tiba di toko.'
                                : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                    ? 'Kode QR akan aktif setelah pesanan Anda dikonfirmasi oleh toko.'
                                    : (currentOrder.orderStatus == OrderStatus.processing
                                        ? 'Kode QR akan aktif setelah toko menyelesaikan persiapan pesanan.'
                                        : 'Status pesanan: ${currentOrder.status}')),
                            style: TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 11.5,
                              color: isQrActive
                                  ? const Color(0xFF64748B)
                                  : (currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                      ? const Color(0xFFB45309)
                                      : const Color(0xFF64748B)),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Kode Pengambilan Card (Matching Screenshot 3)
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
                  children: [
                    // Header with Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kode pengambilan',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
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
                    const SizedBox(height: 20),

                    // QR Code Container with Real Dynamic QR Generator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Opacity(
                            opacity: isQrActive ? 1.0 : 0.45,
                            child: DynamicQrCode(
                              data: currentOrder.orderNumber,
                              size: 190,
                              darkColor: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        if (!isQrActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  currentOrder.orderStatus == OrderStatus.pendingConfirmation
                                      ? Icons.hourglass_top_rounded
                                      : Icons.lock_outline_rounded,
                                  size: 16,
                                  color: currentOrder.statusColor,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'QR BELUM AKTIF',
                                  style: TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: currentOrder.statusColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Text(
                      isQrActive
                          ? 'Pindai kode ini di toko untuk mengonfirmasi pengambilan'
                          : 'Kode QR akan aktif secara otomatis saat pesanan siap diambil',
                      style: const TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // Order Code + Copy Button
                    InkWell(
                      onTap: () =>
                          _copyOrderCode(context, currentOrder.orderNumber),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cleanCode,
                              style: const TextStyle(
                                fontFamily: AppTheme.headingFontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF047857),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.copy_rounded,
                              size: 17,
                              color: Color(0xFF047857),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Lokasi Pengambilan Card (Matching Screenshot 3)
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
                      'Lokasi pengambilan',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
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
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.calendar_month_outlined,
                              color: AppTheme.primaryColor,
                              size: 18,
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
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 15,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Bawa wadah sendiri dan tunjukkan kode ini kepada penjual.',
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
                  // Button 1: Chat Toko
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

                  // Button 2: Petunjuk Arah
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _showDirectionDialog(context, currentOrder),
                      icon: const Icon(
                        Icons.near_me_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Petunjuk Arah',
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047857),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
