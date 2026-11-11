import 'package:flutter/material.dart';
import 'package:foodrescue/features/buyer/models/cart_item_model.dart';
import 'package:foodrescue/features/buyer/models/order_model.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class OrderManager extends ChangeNotifier {
  static final OrderManager _instance = OrderManager._internal();
  factory OrderManager() => _instance;

  OrderManager._internal() {
    _initDefaultOrders();
  }

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  int get completedCount =>
      _orders.where((o) => o.orderStatus == OrderStatus.completed).length;

  void _initDefaultOrders() {
    // 1. Order PK-240318 (Toko Sayur Ibu Ida)
    final productSayur = const FeedProduct(
      id: 'prod_sayur_ida',
      sellerName: 'Toko Sayur Ibu Ida',
      name: 'Sisa Sayuran & Kol',
      category: 'Sayur & Buah',
      stock: '3 Kg',
      price: 500,
      priceUnit: '/Kg',
      distanceKm: 2.8,
      status: 'Segera',
      placeholderIcon: Icons.eco_rounded,
      placeholderColor: Color(0xFFDCFCE7),
      locationAddress: 'Caringin, Lampung',
      operatingHours: '06:00 - 11:00 WIB',
    );

    final productKelapa = const FeedProduct(
      id: 'prod_kelapa',
      sellerName: 'Parutan kelapa Mas Bejo',
      name: 'Ampas Kelapa',
      category: 'Sayur & Buah',
      stock: '5 Kg',
      price: 500,
      priceUnit: '/Kg',
      distanceKm: 3.5,
      status: 'Tersedia',
      placeholderIcon: Icons.grass_rounded,
      placeholderColor: Color(0xFFDCFCE7),
      locationAddress: 'Kedaton, Bandar Lampung',
    );

    final productTahu = const FeedProduct(
      id: 'prod_tahu_yahu',
      sellerName: 'Pabrik Tahu Yahu',
      name: 'Ampas tahu Baru',
      category: 'Olahan & Ampas',
      stock: '10 Kg',
      price: 2333,
      priceUnit: '/Kg',
      distanceKm: 4.2,
      status: 'Tersedia',
      placeholderIcon: Icons.local_drink_rounded,
      placeholderColor: Color(0xFFE0F2FE),
      locationAddress: 'Sukarame, Bandar Lampung',
    );

    _orders.addAll([
      // Card 1: 18 Mar 2026 - Toko Sayur Ibu Ida (PK-240318)
      OrderModel(
        orderNumber: '#PK-240318',
        items: [
          CartItem(product: productSayur, quantity: 2, isSelected: true),
        ],
        storeName: 'Toko Sayur Ibu Ida',
        storeAddress: 'Caringin, Lampung',
        distanceKm: 2.8,
        pickupSchedule: 'Hari ini',
        pickupTime: 'Hari ini, 10:00 WIB',
        notes: 'Bawa karung sendiri',
        subtotal: 1000,
        fee: 0,
        total: 1000,
        createdAt: DateTime(2026, 3, 18, 10, 12),
        orderStatus: OrderStatus.readyForPickup,
        displayProductName: 'Sayuran Hijau & Kol',
        displayQuantity: '2Kg',
        displayPriceUnit: 'Rp 500 /Kg',
        displayIcon: Icons.eco_rounded,
        displayIconBg: const Color(0xFFE0F2FE),
        displayIconColor: const Color(0xFF059669),
      ),

      // Card 2: 11 Mar 2026 - Toko Sayur Pak Martini (PK-240311)
      OrderModel(
        orderNumber: '#PK-240311',
        items: [
          CartItem(
            product: productSayur.copyWith(
              sellerName: 'Toko Sayur Pak Martini',
              name: 'Sayuran Hijau & Kol',
            ),
            quantity: 1,
            isSelected: true,
          ),
        ],
        storeName: 'Toko Sayur Pak Martini',
        storeAddress: 'Way Halim, Lampung',
        distanceKm: 3.1,
        pickupSchedule: '11 Mar 2026',
        pickupTime: '11 Mar 2026, 09:12 WIB',
        notes: '',
        subtotal: 500,
        fee: 0,
        total: 500,
        createdAt: DateTime(2026, 3, 11, 9, 12),
        orderStatus: OrderStatus.completed,
        displayProductName: 'Sayuran Hijau & Kol',
        displayQuantity: '1Kg',
        displayPriceUnit: 'Rp 500 /Kg',
        displayIcon: Icons.eco_rounded,
        displayIconBg: const Color(0xFFE0F2FE),
        displayIconColor: const Color(0xFF059669),
      ),

      // Card 3: 18 Feb 2026 - Parutan kelapa Mas Bejo (PK-240218)
      OrderModel(
        orderNumber: '#PK-240218',
        items: [
          CartItem(product: productKelapa, quantity: 2, isSelected: true),
        ],
        storeName: 'Parutan kelapa Mas Bejo',
        storeAddress: 'Kedaton, Bandar Lampung',
        distanceKm: 3.5,
        pickupSchedule: '18 Feb 2026',
        pickupTime: '18 Feb 2026, 10:20 WIB',
        notes: '',
        subtotal: 1000,
        fee: 0,
        total: 1000,
        createdAt: DateTime(2026, 2, 18, 10, 20),
        orderStatus: OrderStatus.completed,
        displayProductName: 'Ampas Kelapa',
        displayQuantity: '2Kg',
        displayPriceUnit: 'Rp 500 /Kg',
        displayIcon: Icons.grass_rounded,
        displayIconBg: const Color(0xFFE0F2FE),
        displayIconColor: const Color(0xFF059669),
      ),

      // Card 4: 12 Feb 2026 - Pabrik Tahu Yahu (PK-240212)
      OrderModel(
        orderNumber: '#PK-240212',
        items: [
          CartItem(product: productTahu, quantity: 6, isSelected: true),
        ],
        storeName: 'Pabrik Tahu Yahu',
        storeAddress: 'Sukarame, Bandar Lampung',
        distanceKm: 4.2,
        pickupSchedule: '12 Feb 2026',
        pickupTime: '12 Feb 2026, 09:25 WIB',
        notes: '',
        subtotal: 14000,
        fee: 0,
        total: 14000,
        createdAt: DateTime(2026, 2, 12, 9, 25),
        orderStatus: OrderStatus.completed,
        displayProductName: 'Ampas tahu Baru',
        displayQuantity: '6Kg',
        displayPriceUnit: 'Rp 2.333 /Kg',
        displayIcon: Icons.local_drink_rounded,
        displayIconBg: const Color(0xFFE0F2FE),
        displayIconColor: const Color(0xFF0284C7),
      ),

      // Additional completed transactions to total 12 selesai matching screenshot!
      ...List.generate(9, (index) {
        final day = 10 - index;
        final orderNum = '#PK-24010$index';
        return OrderModel(
          orderNumber: orderNum,
          items: [
            CartItem(product: productSayur, quantity: 2, isSelected: true),
          ],
          storeName: 'Toko Sayur Ibu Ida',
          storeAddress: 'Caringin, Lampung',
          distanceKm: 2.8,
          pickupSchedule: '$day Jan 2026',
          pickupTime: '$day Jan 2026, 08:30 WIB',
          notes: '',
          subtotal: 1000,
          fee: 0,
          total: 1000,
          createdAt: DateTime(2026, 1, day, 8, 30),
          orderStatus: OrderStatus.completed,
          displayProductName: 'Sayuran Hijau & Kol',
          displayQuantity: '2Kg',
          displayPriceUnit: 'Rp 500 /Kg',
          displayIcon: Icons.eco_rounded,
          displayIconBg: const Color(0xFFE0F2FE),
          displayIconColor: const Color(0xFF059669),
        );
      }),
    ]);
  }

  void addOrder(OrderModel order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  /// General method to update order status by orderNumber
  bool updateOrderStatus(String orderNumber, OrderStatus newStatus) {
    final cleanNum = orderNumber.startsWith('#')
        ? orderNumber
        : '#$orderNumber';

    final index = _orders.indexWhere(
      (o) => o.orderNumber == cleanNum || o.orderNumber == orderNumber,
    );

    if (index != -1) {
      _orders[index] = _orders[index].copyWith(orderStatus: newStatus);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Simulation method: Seller confirms order (moves from pendingConfirmation to processing)
  bool confirmOrderBySeller(String orderNumber) {
    return updateOrderStatus(orderNumber, OrderStatus.processing);
  }

  /// Alias for confirmOrderBySeller
  bool confirmOrder(String orderNumber) => confirmOrderBySeller(orderNumber);

  /// Simulation method: Seller finishes preparation (moves to readyForPickup)
  bool markOrderReadyForPickup(String orderNumber) {
    return updateOrderStatus(orderNumber, OrderStatus.readyForPickup);
  }

  /// Alias for markOrderReadyForPickup
  bool setReadyForPickup(String orderNumber) => markOrderReadyForPickup(orderNumber);

  /// Simulation method: Order is picked up / completed
  bool completeOrder(String orderNumber) {
    return updateOrderStatus(orderNumber, OrderStatus.completed);
  }

  /// Cancel order
  bool cancelOrder(String orderNumber) {
    final cleanNum = orderNumber.startsWith('#')
        ? orderNumber
        : '#$orderNumber';

    final index = _orders.indexWhere(
      (o) => o.orderNumber == cleanNum || o.orderNumber == orderNumber,
    );

    if (index != -1) {
      final current = _orders[index];
      if (!current.canBeCancelled) return false;

      _orders[index] = current.copyWith(
        orderStatus: OrderStatus.cancelled,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  OrderModel? getOrder(String orderNumber) {
    final cleanNum = orderNumber.startsWith('#')
        ? orderNumber
        : '#$orderNumber';

    final index = _orders.indexWhere(
      (o) => o.orderNumber == cleanNum || o.orderNumber == orderNumber,
    );

    if (index != -1) {
      return _orders[index];
    }
    return null;
  }

  /// Filter orders by 5 status tabs and optional search query
  List<OrderModel> getFilteredOrders({
    String statusFilter = 'Semua',
    String searchQuery = '',
  }) {
    final query = searchQuery.trim().toLowerCase();

    return _orders.where((order) {
      // 1. Status Filter
      if (statusFilter != 'Semua') {
        switch (statusFilter) {
          case 'Menunggu Konfirmasi':
            if (order.orderStatus != OrderStatus.pendingConfirmation) {
              return false;
            }
            break;
          case 'Diproses':
            if (order.orderStatus != OrderStatus.processing &&
                order.orderStatus != OrderStatus.readyForPickup) {
              return false;
            }
            break;
          case 'Selesai':
            if (order.orderStatus != OrderStatus.completed) {
              return false;
            }
            break;
          case 'Dibatalkan':
            if (order.orderStatus != OrderStatus.cancelled) {
              return false;
            }
            break;
        }
      }

      // 2. Search Query Filter
      if (query.isNotEmpty) {
        final matchOrderNum = order.orderNumber.toLowerCase().contains(query);
        final matchStore = order.storeName.toLowerCase().contains(query);
        final matchProduct = order.primaryProductName.toLowerCase().contains(query);

        if (!matchOrderNum && !matchStore && !matchProduct) {
          return false;
        }
      }

      return true;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
