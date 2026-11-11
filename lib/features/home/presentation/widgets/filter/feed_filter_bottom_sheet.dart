import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/data/dummy_feed_data.dart';
import 'package:foodrescue/features/home/models/feed_filter_model.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class FeedFilterBottomSheet extends StatefulWidget {
  final FeedFilter currentFilter;
  final List<FeedProduct> allProducts;
  final ValueChanged<FeedFilter> onApply;

  const FeedFilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.allProducts,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required FeedFilter currentFilter,
    required List<FeedProduct> allProducts,
    required ValueChanged<FeedFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FeedFilterBottomSheet(
            currentFilter: currentFilter,
            allProducts: allProducts,
            onApply: onApply,
          ),
        );
      },
    );
  }

  @override
  State<FeedFilterBottomSheet> createState() => _FeedFilterBottomSheetState();
}

class _FeedFilterBottomSheetState extends State<FeedFilterBottomSheet> {
  late Set<String> _selectedCategories;
  late double _radiusKm;
  late String _radiusLabel;
  late String _feeType;
  late String _readyTime;

  static const List<Map<String, dynamic>> _radiusOptions = [
    {'label': '< 3 km', 'value': 3.0},
    {'label': '5 km', 'value': 5.0},
    {'label': '10 km', 'value': 10.0},
    {'label': '15 km', 'value': 15.0},
    {'label': '> 20 km', 'value': 999.0},
  ];

  static const List<String> _feeOptions = [
    'Semua',
    'Donasi Gratis',
    'Berbayar Murah',
  ];

  static const List<String> _readyTimeOptions = [
    'Siap Ambil Hari Ini',
    'Segar (< 12 Jam)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.currentFilter.selectedCategories);
    _radiusKm = widget.currentFilter.radiusKm;
    _radiusLabel = widget.currentFilter.radiusLabel;
    _feeType = widget.currentFilter.feeType;
    _readyTime = widget.currentFilter.readyTime;
  }

  void _resetFilter() {
    setState(() {
      _selectedCategories.clear();
      _radiusKm = 5.0;
      _radiusLabel = '5 km';
      _feeType = 'Semua';
      _readyTime = 'Siap Ambil Hari Ini';
    });
  }

  int _calculateMatchedCount() {
    final tempFilter = FeedFilter(
      selectedCategories: _selectedCategories,
      radiusKm: _radiusKm,
      radiusLabel: _radiusLabel,
      feeType: _feeType,
      readyTime: _readyTime,
    );

    return widget.allProducts.where((p) {
      if (tempFilter.selectedCategories.isNotEmpty &&
          !tempFilter.selectedCategories.contains(p.category)) {
        return false;
      }
      if (p.distanceKm > tempFilter.radiusKm) {
        return false;
      }
      if (tempFilter.feeType == 'Donasi Gratis' && !p.isFree) {
        return false;
      }
      if (tempFilter.feeType == 'Berbayar Murah' && p.isFree) {
        return false;
      }
      return true;
    }).length;
  }

  void _applyFilter() {
    final result = FeedFilter(
      selectedCategories: _selectedCategories,
      radiusKm: _radiusKm,
      radiusLabel: _radiusLabel,
      feeType: _feeType,
      readyTime: _readyTime,
    );
    widget.onApply(result);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final matchedCount = _calculateMatchedCount();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Drag Handle
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // Header Row: Title, Subtitle, Reset, and Close
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Filter Pakan & Radius',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sesuaikan pencarian kebutuhan ternak Anda',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilter,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Scrollable Filter Sections
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Kategori Pakan
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.grain_rounded,
                              size: 18,
                              color: AppTheme.primaryColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Kategori Pakan',
                              style: TextStyle(
                                fontFamily: AppTheme.headingFontFamily,
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.neutralColor,
                              ),
                            ),
                          ],
                        ),
                        if (_selectedCategories.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_selectedCategories.length} Dipilih',
                              style: const TextStyle(
                                fontFamily: AppTheme.bodyFontFamily,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: DummyFeedData.allFilterCategories.map((cat) {
                        final isSelected = _selectedCategories.contains(cat);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedCategories.remove(cat);
                              } else {
                                _selectedCategories.add(cat);
                              }
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF047857)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF047857)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                ],
                                Text(
                                  cat,
                                  style: TextStyle(
                                    fontFamily: AppTheme.bodyFontFamily,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Radius Jarak Maksimal
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.near_me_outlined,
                                    size: 18,
                                    color: AppTheme.primaryColor,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Radius Jarak Maksimal',
                                    style: TextStyle(
                                      fontFamily: AppTheme.headingFontFamily,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.neutralColor,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF86EFAC),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _radiusLabel,
                                  style: const TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Maksimal $_radiusLabel dari lokasi Anda (Bandar Lampung)',
                                  style: const TextStyle(
                                    fontFamily: AppTheme.bodyFontFamily,
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Radius Option Buttons in Row
                          Row(
                            children: _radiusOptions.map((opt) {
                              final label = opt['label'] as String;
                              final val = opt['value'] as double;
                              final isSelected = _radiusLabel == label;

                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _radiusLabel = label;
                                        _radiusKm = val;
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF047857)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF047857)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontFamily: AppTheme.bodyFontFamily,
                                          fontSize: 11,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Tipe Biaya / Status Pakan
                    Row(
                      children: const [
                        Icon(
                          Icons.payments_outlined,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Tipe Biaya / Status Pakan',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: _feeOptions.map((fee) {
                        final isSelected = _feeType == fee;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _feeType = fee;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFECFDF5)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : const Color(0xFFE2E8F0),
                                    width: isSelected ? 1.5 : 1,
                                  ),
                                ),
                                child: Text(
                                  fee,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.headingFontFamily,
                                    fontSize: 11.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Section 4: Waktu Siap Angkut
                    Row(
                      children: const [
                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Waktu Siap Angkut',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _readyTimeOptions.map((time) {
                        final isSelected = _readyTime == time;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _readyTime = time;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF047857)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF047857)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontFamily: AppTheme.bodyFontFamily,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Apply Button
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _applyFilter,
                  icon: const Icon(Icons.filter_alt_outlined, size: 18),
                  label: Text(
                    'Terapkan Filter ($matchedCount Hasil Ditemukan)',
                    style: const TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF047857),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

