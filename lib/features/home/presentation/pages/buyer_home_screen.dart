import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/presentation/pages/cart_page.dart';
import 'package:foodrescue/features/buyer/presentation/pages/product_detail_page.dart';
import 'package:foodrescue/features/chat/presentation/pages/chat_list_page.dart';
import 'package:foodrescue/features/history/presentation/pages/transaction_history_page.dart';
import 'package:foodrescue/features/home/data/dummy_feed_data.dart';
import 'package:foodrescue/features/home/models/feed_filter_model.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';
import 'package:foodrescue/features/home/presentation/widgets/buyer_bottom_navigation_bar.dart';
import 'package:foodrescue/features/home/presentation/widgets/category_section.dart';
import 'package:foodrescue/features/home/presentation/widgets/filter/feed_filter_bottom_sheet.dart';
import 'package:foodrescue/features/home/presentation/widgets/home_header.dart';
import 'package:foodrescue/features/home/presentation/widgets/home_search_bar.dart';
import 'package:foodrescue/features/home/presentation/widgets/product_grid_section.dart';
import 'package:foodrescue/features/home/presentation/widgets/promo_banner.dart';
import 'package:foodrescue/features/profile/presentation/pages/buyer_profile_page.dart';

class BuyerHomeScreen extends StatefulWidget {
  final int initialTabIndex;

  const BuyerHomeScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  late int _currentTabIndex;

  final TextEditingController _searchController = TextEditingController();
  late List<FeedProduct> _allProducts;
  late FeedFilter _currentFilter;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
    _allProducts = List.from(DummyFeedData.products);
    _currentFilter = FeedFilter.initial();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FeedProduct> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();

    return _allProducts.where((product) {
      // 1. Search Query Filter
      if (query.isNotEmpty) {
        final matchName = product.name.toLowerCase().contains(query);
        final matchSeller = product.sellerName.toLowerCase().contains(query);
        final matchCategory = product.category.toLowerCase().contains(query);
        if (!matchName && !matchSeller && !matchCategory) {
          return false;
        }
      }

      // 2. Quick Category Selection (from horizontal bar)
      if (_selectedCategory != null) {
        if (!product.category.toLowerCase().contains(_selectedCategory!.toLowerCase())) {
          return false;
        }
      }

      // 3. Bottom Sheet Filter Categories
      if (_currentFilter.selectedCategories.isNotEmpty) {
        if (!_currentFilter.selectedCategories.contains(product.category)) {
          return false;
        }
      }

      // 4. Radius Filter
      if (product.distanceKm > _currentFilter.radiusKm) {
        return false;
      }

      // 5. Fee Type Filter
      if (_currentFilter.feeType == 'Donasi Gratis' && !product.isFree) {
        return false;
      }
      if (_currentFilter.feeType == 'Berbayar Murah' && product.isFree) {
        return false;
      }

      return true;
    }).toList();
  }

  void _openFilterBottomSheet() {
    FeedFilterBottomSheet.show(
      context: context,
      currentFilter: _currentFilter,
      allProducts: _allProducts,
      onApply: (newFilter) {
        setState(() {
          _currentFilter = newFilter;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Filter diterapkan: ${_filteredProducts.length} hasil ditemukan',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _toggleFavorite(FeedProduct product) {
    setState(() {
      final index = _allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        final currentFav = _allProducts[index].isFavorite;
        _allProducts[index] = _allProducts[index].copyWith(
          isFavorite: !currentFav,
        );
      }
    });
  }

  void _handleCategorySelect(String categoryName) {
    setState(() {
      if (_selectedCategory == categoryName) {
        _selectedCategory = null;
      } else {
        _selectedCategory = categoryName;
      }
    });
  }

  void _resetAllFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _currentFilter = FeedFilter.initial();
    });
  }

  Widget _buildHomeTab() {
    final filteredList = _filteredProducts;

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      color: AppTheme.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header
            const HomeHeader(),

            // 2. Promotional Banner
            PromoBanner(
              onCheckSurplusTap: () {
                // Smoothly focus on products
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menampilkan surplus pakan hari ini di sekitar Anda'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),

            // 3. Search Bar & Filter Button
            HomeSearchBar(
              controller: _searchController,
              hasActiveFilter: !_currentFilter.isDefault || _selectedCategory != null,
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchController.clear();
                setState(() {});
              },
              onFilterTap: _openFilterBottomSheet,
            ),
            const SizedBox(height: 6),

            // 4. Kategori Pakan Horizontal Section
            CategorySection(
              categories: DummyFeedData.categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: _handleCategorySelect,
            ),
            const SizedBox(height: 8),

            // 5. Rekomendasi Terdekat Product Grid
            ProductGridSection(
              products: filteredList,
              activeRadiusLabel: 'Filter Radius',
              onFilterRadiusTap: _openFilterBottomSheet,
              onFavoriteToggle: _toggleFavorite,
              onResetFilter: _resetAllFilters,
              onDetailTap: (product) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(product: product),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildHomeTab(),
            CartPage(
              showBottomNav: false,
              onNavigateToHome: () {
                setState(() {
                  _currentTabIndex = 0;
                });
              },
            ),
            const ChatListPage(),
            const TransactionHistoryPage(),
            const BuyerProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BuyerBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}
