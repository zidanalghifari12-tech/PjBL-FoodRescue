import 'package:flutter/material.dart';

class FeedProduct {
  final String id;
  final String sellerName;
  final String name;
  final String category;
  final String stock;
  final int price;
  final String priceUnit;
  final double distanceKm;
  final String status; // 'Tersedia' | 'Segera'
  final bool isFavorite;
  final bool isFree;
  final String readyTime; // 'Siap Ambil Hari Ini' | 'Segar (<12 Jam)'
  final IconData placeholderIcon;
  final Color placeholderColor;

  // Additional detail fields for ProductDetailPage
  final String remainingTime;
  final String condition;
  final String locationAddress;
  final String operatingHours;
  final String pickupShift;
  final bool isOpen;
  final int maxStockKg;
  final String badgeText;
  final List<String> photos;

  const FeedProduct({
    required this.id,
    required this.sellerName,
    required this.name,
    required this.category,
    required this.stock,
    required this.price,
    this.priceUnit = '/kg',
    required this.distanceKm,
    required this.status,
    this.isFavorite = false,
    this.isFree = false,
    this.readyTime = 'Siap Ambil Hari Ini',
    required this.placeholderIcon,
    required this.placeholderColor,
    this.remainingTime = '1 Jam lagi',
    this.condition = 'Sortiran Bersih Tanpa Plastik',
    this.locationAddress = 'Caringin, Lampung',
    this.operatingHours = '06:00 - 11:00 WIB',
    this.pickupShift = 'Jam Angkut Pagi-Siang',
    this.isOpen = true,
    this.maxStockKg = 5,
    this.badgeText = 'Harga Murah',
    this.photos = const ['Foto Batch 1', 'Foto Batch 2', 'Foto Batch 3'],
  });

  FeedProduct copyWith({
    String? id,
    String? sellerName,
    String? name,
    String? category,
    String? stock,
    int? price,
    String? priceUnit,
    double? distanceKm,
    String? status,
    bool? isFavorite,
    bool? isFree,
    String? readyTime,
    IconData? placeholderIcon,
    Color? placeholderColor,
    String? remainingTime,
    String? condition,
    String? locationAddress,
    String? operatingHours,
    String? pickupShift,
    bool? isOpen,
    int? maxStockKg,
    String? badgeText,
    List<String>? photos,
  }) {
    return FeedProduct(
      id: id ?? this.id,
      sellerName: sellerName ?? this.sellerName,
      name: name ?? this.name,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      priceUnit: priceUnit ?? this.priceUnit,
      distanceKm: distanceKm ?? this.distanceKm,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
      isFree: isFree ?? this.isFree,
      readyTime: readyTime ?? this.readyTime,
      placeholderIcon: placeholderIcon ?? this.placeholderIcon,
      placeholderColor: placeholderColor ?? this.placeholderColor,
      remainingTime: remainingTime ?? this.remainingTime,
      condition: condition ?? this.condition,
      locationAddress: locationAddress ?? this.locationAddress,
      operatingHours: operatingHours ?? this.operatingHours,
      pickupShift: pickupShift ?? this.pickupShift,
      isOpen: isOpen ?? this.isOpen,
      maxStockKg: maxStockKg ?? this.maxStockKg,
      badgeText: badgeText ?? this.badgeText,
      photos: photos ?? this.photos,
    );
  }
}
