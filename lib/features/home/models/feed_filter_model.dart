class FeedFilter {
  final Set<String> selectedCategories;
  final double radiusKm;
  final String radiusLabel;
  final String feeType; // 'Semua' | 'Donasi Gratis' | 'Berbayar Murah'
  final String readyTime; // 'Siap Ambil Hari Ini' | 'Segar (<12 Jam)'

  const FeedFilter({
    this.selectedCategories = const {},
    this.radiusKm = 5.0,
    this.radiusLabel = '5 km',
    this.feeType = 'Semua',
    this.readyTime = 'Siap Ambil Hari Ini',
  });

  FeedFilter copyWith({
    Set<String>? selectedCategories,
    double? radiusKm,
    String? radiusLabel,
    String? feeType,
    String? readyTime,
  }) {
    return FeedFilter(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      radiusKm: radiusKm ?? this.radiusKm,
      radiusLabel: radiusLabel ?? this.radiusLabel,
      feeType: feeType ?? this.feeType,
      readyTime: readyTime ?? this.readyTime,
    );
  }

  static FeedFilter initial() {
    return const FeedFilter(
      selectedCategories: {},
      radiusKm: 5.0,
      radiusLabel: '5 km',
      feeType: 'Semua',
      readyTime: 'Siap Ambil Hari Ini',
    );
  }

  bool get isDefault =>
      selectedCategories.isEmpty &&
      radiusKm == 5.0 &&
      feeType == 'Semua' &&
      readyTime == 'Siap Ambil Hari Ini';
}

