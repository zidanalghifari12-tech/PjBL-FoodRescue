import 'package:flutter/material.dart';
import 'package:foodrescue/features/buyer/models/cart_item_model.dart';
import 'package:foodrescue/features/home/data/dummy_feed_data.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;

  CartManager._internal() {
    _initDefaultItems();
  }

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void _initDefaultItems() {
    // 1. Toko Sayur Ibu Ida - Sisa Sayuran & Kol (selected in screenshot)
    final product1 = DummyFeedData.products.firstWhere(
      (p) => p.id == 'prod_2',
      orElse: () => const FeedProduct(
        id: 'prod_2',
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
        maxStockKg: 3,
      ),
    );

    // 2. Warung Bu Rini - Pisang Kepok Matang (unselected in screenshot)
    const product2 = FeedProduct(
      id: 'prod_banana',
      sellerName: 'Warung Bu Rini',
      name: 'Pisang Kepok Matang',
      category: 'Sayur & Buah',
      stock: '5 tersedia',
      price: 2000,
      priceUnit: '/Sisir',
      distanceKm: 1.5,
      status: 'Tersedia',
      placeholderIcon: Icons.apple_rounded,
      placeholderColor: Color(0xFFFEF3C7),
      maxStockKg: 5,
      remainingTime: '3 Jam lagi',
      condition: 'Kondisi Matang Manis Alami',
      locationAddress: 'Kedaton, Bandar Lampung',
      operatingHours: '07:00 - 17:00 WIB',
      pickupShift: 'Jam Buka Toko',
      isOpen: true,
      badgeText: 'Harga Murah',
    );

    _items.addAll([
      CartItem(product: product1, quantity: 2, isSelected: true),
      CartItem(product: product2, quantity: 1, isSelected: false),
    ]);
  }

  void addItem(FeedProduct product, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      final newQty = (_items[existingIndex].quantity + quantity).clamp(
        1,
        product.maxStockKg,
      );
      _items[existingIndex].quantity = newQty;
      _items[existingIndex].isSelected = true;
    } else {
      _items.add(
        CartItem(
          product: product,
          quantity: quantity.clamp(1, product.maxStockKg),
          isSelected: true,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final maxStock = _items[index].product.maxStockKg;
      _items[index].quantity = newQuantity.clamp(1, maxStock);
      notifyListeners();
    }
  }

  void toggleItemSelection(String productId, bool? isSelected) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].isSelected = isSelected ?? false;
      notifyListeners();
    }
  }

  void toggleStoreSelection(String sellerName, bool isSelected) {
    for (final item in _items) {
      if (item.product.sellerName == sellerName) {
        item.isSelected = isSelected;
      }
    }
    notifyListeners();
  }

  void toggleSelectAll(bool isSelected) {
    for (final item in _items) {
      item.isSelected = isSelected;
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((item) => item.isSelected);

  bool isStoreSelected(String sellerName) {
    final storeItems = _items.where((item) => item.product.sellerName == sellerName).toList();
    if (storeItems.isEmpty) return false;
    return storeItems.every((item) => item.isSelected);
  }

  int get selectedTotalCost => _items
      .where((item) => item.isSelected)
      .fold(0, (sum, item) => sum + item.totalPrice);

  int get selectedItemCount =>
      _items.where((item) => item.isSelected).length;

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

