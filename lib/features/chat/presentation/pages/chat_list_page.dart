import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/chat/data/chat_manager.dart';
import 'package:foodrescue/features/chat/models/chat_conversation_model.dart';
import 'package:foodrescue/features/chat/presentation/pages/store_chat_page.dart';
import 'package:foodrescue/features/home/presentation/pages/buyer_home_screen.dart';
import 'package:foodrescue/features/home/presentation/widgets/buyer_bottom_navigation_bar.dart';

class ChatListPage extends StatefulWidget {
  final bool showBottomNav;

  const ChatListPage({
    super.key,
    this.showBottomNav = false,
  });

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatManager _chatManager = ChatManager();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';

  final List<String> _filters = const [
    'Semua',
    'Belum dibaca',
    'Pernah membeli',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onChatTap(ChatConversationModel chat) {
    // 1. Mark conversation as read (badge updates when opened)
    _chatManager.markAsRead(chat.id);

    // 2. Navigate to existing StoreChatPage without duplicating pages
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoreChatPage(
          storeName: chat.storeName,
          storeLocation: chat.storeLocation,
        ),
      ),
    );
  }

  Widget _buildFilterPill(String filter) {
    final isSelected = _selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = filter;
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
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF047857).withValues(alpha: 0.18),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            filter,
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

  Widget _buildConversationCard(ChatConversationModel chat) {
    final unread = chat.unreadCount;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unread > 0
              ? const Color(0xFFDCFCE7)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _onChatTap(chat),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Icon Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: chat.iconBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    chat.icon,
                    color: chat.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),

                // Main Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Store Name & Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              chat.storeName,
                              style: TextStyle(
                                fontFamily: AppTheme.headingFontFamily,
                                fontSize: 14,
                                fontWeight: unread > 0
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: AppTheme.neutralColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            chat.time,
                            style: TextStyle(
                              fontFamily: AppTheme.bodyFontFamily,
                              fontSize: 11,
                              color: unread > 0
                                  ? const Color(0xFF047857)
                                  : const Color(0xFF94A3B8),
                              fontWeight: unread > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),

                      // "Pernah membeli" badge if buyer previously bought from this store
                      if (chat.hasPurchased) ...[
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFDCFCE7),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.verified_outlined,
                                size: 11,
                                color: Color(0xFF047857),
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Pernah membeli',
                                style: TextStyle(
                                  fontFamily: AppTheme.headingFontFamily,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF047857),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 4),

                      // Preview message & Unread Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chat.lastMessage,
                              style: TextStyle(
                                fontFamily: AppTheme.bodyFontFamily,
                                fontSize: 12,
                                color: unread > 0
                                    ? AppTheme.neutralColor
                                    : const Color(0xFF64748B),
                                fontWeight: unread > 0
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (unread > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF059669),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$unread',
                                style: const TextStyle(
                                  fontFamily: AppTheme.headingFontFamily,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Pesan',
              style: TextStyle(
                fontFamily: AppTheme.headingFontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutralColor,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Chat dengan toko langgananmu',
              style: TextStyle(
                fontFamily: AppTheme.bodyFontFamily,
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _chatManager,
        builder: (context, _) {
          final filteredChats = _chatManager.getFilteredConversations(
            filter: _selectedFilter,
            searchQuery: _searchController.text,
          );

          return Column(
            children: [
              // Search Bar & Filter Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Cari nama toko atau pesan',
                        hintStyle: const TextStyle(
                          fontFamily: AppTheme.bodyFontFamily,
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF94A3B8),
                          size: 20,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Color(0xFF94A3B8),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF047857)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Pill Filters (Semua, Belum dibaca, Pernah membeli)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: _filters
                            .map((filter) => _buildFilterPill(filter))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // Conversation List
              Expanded(
                child: filteredChats.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 48,
                                color: Color(0xFF94A3B8),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Tidak ada pesan ditemukan',
                                style: TextStyle(
                                  fontFamily: AppTheme.headingFontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.neutralColor,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Coba cari dengan kata kunci lain atau pilih filter yang berbeda.',
                                style: TextStyle(
                                  fontFamily: AppTheme.bodyFontFamily,
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredChats.length,
                        itemBuilder: (context, index) {
                          return _buildConversationCard(filteredChats[index]);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BuyerBottomNavBar(
              currentIndex: 2,
              onTap: (index) {
                if (index == 2) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => BuyerHomeScreen(initialTabIndex: index),
                  ),
                  (route) => false,
                );
              },
            )
          : null,
    );
  }
}
