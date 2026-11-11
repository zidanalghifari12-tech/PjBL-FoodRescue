import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/buyer/models/order_model.dart';
import 'package:foodrescue/features/buyer/presentation/pages/order_confirmation_page.dart';
import 'package:foodrescue/features/history/data/order_manager.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';

class TransactionHistoryPage extends StatefulWidget {
  final bool showBottomNav;

  const TransactionHistoryPage({
    super.key,
    this.showBottomNav = false,
  });

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final OrderManager _orderManager = OrderManager();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';
  bool _isSearching = false;

  final List<String> _filters = const [
    'Semua',
    'Menunggu Konfirmasi',
    'Diproses',
    'Selesai',
    'Dibatalkan',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _openOrderDetail(OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderConfirmationPage(order: order),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF047857) : Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionCard(OrderModel order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openOrderDetail(order),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Date & Status Badge (Matching Screenshot 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          order.formattedDate,
                          style: const TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: order.statusBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.statusBadge,
                        style: TextStyle(
                          fontFamily: AppTheme.headingFontFamily,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: order.statusColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Middle Row: Category Icon, Product Name, Store & Qty, Chevron
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: order.displayIconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        order.displayIcon,
                        color: order.displayIconColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.primaryProductName,
                            style: const TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neutralColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${order.storeName} · ${order.primaryQuantity}',
                            style: const TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 10),

                // Bottom Row: Total pembayaran & Price (Matching Screenshot 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total pembayaran',
                      style: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    Text(
                      'Rp${_formatNumber(order.total)}',
                      style: const TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _orderManager,
      builder: (context, _) {
        final filteredOrders = _orderManager.getFilteredOrders(
          statusFilter: _selectedFilter,
          searchQuery: _searchController.text,
        );

        final completedCount = _orderManager.completedCount;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppTheme.neutralColor),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const BuyerHomeScreen(initialTabIndex: 0),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Cari produk, toko, nomor pesanan...',
                      hintStyle: TextStyle(
                        fontFamily: AppTheme.bodyFontFamily,
                        fontSize: 13,
                        color: Color(0xFF94A3B8),
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 13,
                    ),
                  )
                : const Text(
                    'Riwayat Transaksi',
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
                icon: Icon(
                  _isSearching ? Icons.close_rounded : Icons.search_rounded,
                  color: AppTheme.neutralColor,
                ),
                onPressed: () {
                  setState(() {
                    if (_isSearching) {
                      _isSearching = false;
                      _searchController.clear();
                    } else {
                      _isSearching = true;
                    }
                  });
                },
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              // 1. Total Transaksi Selesai Card (Matching Screenshot 1)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total transaksi selesai',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedCount transaksi',
                          style: const TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        color: Color(0xFF047857),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Filter Status Chips (5 Filters in exact requested order)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _filters.map((filter) => _buildFilterChip(filter)).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // 3. List of Transactions
              if (filteredOrders.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48.0),
                    child: Column(
                      children: const [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada transaksi ditemukan',
                          style: TextStyle(
                            fontFamily: AppTheme.headingFontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neutralColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Transaksi Anda akan muncul di sini setelah memesan.',
                          style: TextStyle(
                            fontFamily: AppTheme.bodyFontFamily,
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...filteredOrders.map((order) => _buildTransactionCard(order)),
            ],
          ),
        );
      },
    );
  }
}
