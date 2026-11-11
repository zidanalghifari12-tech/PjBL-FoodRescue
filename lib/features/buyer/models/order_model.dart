import 'package:flutter/material.dart';
import 'package:foodrescue/features/buyer/models/cart_item_model.dart';

enum OrderStatus {
  pendingConfirmation(
    'pending_confirmation',
    'Menunggu Konfirmasi',
    'MENUNGGU KONFIRMASI',
  ),
  processing(
    'processing',
    'Diproses',
    'DIPROSES',
  ),
  readyForPickup(
    'ready_for_pickup',
    'Siap Diambil',
    'SIAP DIAMBIL',
  ),
  completed(
    'completed',
    'Selesai',
    'SELESAI',
  ),
  cancelled(
    'cancelled',
    'Dibatalkan',
    'DIBATALKAN',
  );

  final String code;
  final String label;
  final String badgeText;

  const OrderStatus(this.code, this.label, this.badgeText);

  static OrderStatus fromString(String? value) {
    if (value == null) return OrderStatus.pendingConfirmation;
    final lower = value.toLowerCase().trim();
    if (lower == 'pending_confirmation' ||
        lower == 'menunggu konfirmasi' ||
        lower == 'menunggu_konfirmasi') {
      return OrderStatus.pendingConfirmation;
    }
    if (lower == 'processing' ||
        lower == 'diproses' ||
        lower == 'pesanan dikonfirmasi' ||
        lower == 'berhasil') {
      return OrderStatus.processing;
    }
    if (lower == 'ready_for_pickup' ||
        lower == 'siap diambil' ||
        lower == 'siap_diambil') {
      return OrderStatus.readyForPickup;
    }
    if (lower == 'completed' || lower == 'selesai') {
      return OrderStatus.completed;
    }
    if (lower == 'cancelled' || lower == 'dibatalkan' || lower == 'batal') {
      return OrderStatus.cancelled;
    }
    return OrderStatus.pendingConfirmation;
  }
}

class OrderModel {
  final String orderNumber;
  final List<CartItem> items;
  final String storeName;
  final String storeAddress;
  final double distanceKm;
  final String pickupSchedule;
  final String pickupTime;
  final String notes;
  final int subtotal;
  final int fee;
  final int total;
  final DateTime createdAt;
  final OrderStatus orderStatus;

  // Additional display helpers
  final String? displayProductName;
  final String? displayQuantity;
  final String? displayPriceUnit;
  final IconData displayIcon;
  final Color displayIconColor;
  final Color displayIconBg;

  const OrderModel({
    required this.orderNumber,
    required this.items,
    required this.storeName,
    required this.storeAddress,
    required this.distanceKm,
    required this.pickupSchedule,
    required this.pickupTime,
    required this.notes,
    required this.subtotal,
    this.fee = 0,
    required this.total,
    required this.createdAt,
    this.orderStatus = OrderStatus.pendingConfirmation,
    this.displayProductName,
    this.displayQuantity,
    this.displayPriceUnit,
    this.displayIcon = Icons.eco_rounded,
    this.displayIconColor = const Color(0xFF059669),
    this.displayIconBg = const Color(0xFFDCFCE7),
  });

  String get status => orderStatus.label;

  String get statusBadge => orderStatus.badgeText;

  String get statusDescription {
    switch (orderStatus) {
      case OrderStatus.pendingConfirmation:
        return 'Pesanan Anda sedang menunggu konfirmasi dari toko.';
      case OrderStatus.processing:
        return 'Pesanan Anda sedang disiapkan oleh toko.';
      case OrderStatus.readyForPickup:
        return 'Pesanan Anda sudah siap diambil di lokasi toko.';
      case OrderStatus.completed:
        return 'Pakan sudah berhasil diambil dan transaksi telah selesai.';
      case OrderStatus.cancelled:
        return 'Pesanan ini telah dibatalkan.';
    }
  }

  Color get statusColor {
    switch (orderStatus) {
      case OrderStatus.pendingConfirmation:
        return const Color(0xFFD97706); // Amber
      case OrderStatus.processing:
        return const Color(0xFF0284C7); // Sky Blue
      case OrderStatus.readyForPickup:
        return const Color(0xFF047857); // Emerald Green
      case OrderStatus.completed:
        return const Color(0xFF047857); // Green
      case OrderStatus.cancelled:
        return const Color(0xFFDC2626); // Red
    }
  }

  Color get statusBgColor {
    switch (orderStatus) {
      case OrderStatus.pendingConfirmation:
        return const Color(0xFFFEF3C7); // Amber-100
      case OrderStatus.processing:
        return const Color(0xFFE0F2FE); // Sky-100
      case OrderStatus.readyForPickup:
        return const Color(0xFFDCFCE7); // Green-100
      case OrderStatus.completed:
        return const Color(0xFFDCFCE7); // Green-100
      case OrderStatus.cancelled:
        return const Color(0xFFFEE2E2); // Red-100
    }
  }

  IconData get statusIcon {
    switch (orderStatus) {
      case OrderStatus.pendingConfirmation:
        return Icons.hourglass_top_rounded;
      case OrderStatus.processing:
        return Icons.inventory_2_outlined;
      case OrderStatus.readyForPickup:
        return Icons.storefront_rounded;
      case OrderStatus.completed:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  bool get isQrActive => orderStatus == OrderStatus.readyForPickup;

  bool get canBeCancelled =>
      orderStatus != OrderStatus.completed &&
      orderStatus != OrderStatus.cancelled;

  String get primaryProductName {
    if (displayProductName != null && displayProductName!.isNotEmpty) {
      return displayProductName!;
    }
    if (items.isNotEmpty) {
      return items.first.product.name;
    }
    return 'Pakan Ternak';
  }

  String get primaryQuantity {
    if (displayQuantity != null && displayQuantity!.isNotEmpty) {
      return displayQuantity!;
    }
    if (items.isNotEmpty) {
      final item = items.first;
      return '${item.quantity} ${item.product.priceUnit == '/Sisir' ? 'Sisir' : 'Kg'}';
    }
    return '1 Kg';
  }

  String get formattedDate {
    final now = DateTime.now();
    final isToday = createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;

    final hourStr = createdAt.hour.toString().padLeft(2, '0');
    final minuteStr = createdAt.minute.toString().padLeft(2, '0');

    if (isToday) {
      return 'Hari ini, $hourStr:$minuteStr WIB';
    }

    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return '${createdAt.day} ${months[createdAt.month]} ${createdAt.year} · $hourStr:$minuteStr';
  }

  OrderModel copyWith({
    String? orderNumber,
    List<CartItem>? items,
    String? storeName,
    String? storeAddress,
    double? distanceKm,
    String? pickupSchedule,
    String? pickupTime,
    String? notes,
    int? subtotal,
    int? fee,
    int? total,
    DateTime? createdAt,
    OrderStatus? orderStatus,
    String? status,
    String? statusBadge,
    String? displayProductName,
    String? displayQuantity,
    String? displayPriceUnit,
    IconData? displayIcon,
    Color? displayIconColor,
    Color? displayIconBg,
  }) {
    OrderStatus resolvedStatus = this.orderStatus;
    if (orderStatus != null) {
      resolvedStatus = orderStatus;
    } else if (status != null) {
      resolvedStatus = OrderStatus.fromString(status);
    }

    return OrderModel(
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      distanceKm: distanceKm ?? this.distanceKm,
      pickupSchedule: pickupSchedule ?? this.pickupSchedule,
      pickupTime: pickupTime ?? this.pickupTime,
      notes: notes ?? this.notes,
      subtotal: subtotal ?? this.subtotal,
      fee: fee ?? this.fee,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      orderStatus: resolvedStatus,
      displayProductName: displayProductName ?? this.displayProductName,
      displayQuantity: displayQuantity ?? this.displayQuantity,
      displayPriceUnit: displayPriceUnit ?? this.displayPriceUnit,
      displayIcon: displayIcon ?? this.displayIcon,
      displayIconColor: displayIconColor ?? this.displayIconColor,
      displayIconBg: displayIconBg ?? this.displayIconBg,
    );
  }
}
