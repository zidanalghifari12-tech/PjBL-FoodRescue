import 'package:flutter/material.dart';
import 'package:foodrescue/features/chat/models/chat_conversation_model.dart';

class ChatManager extends ChangeNotifier {
  static final ChatManager _instance = ChatManager._internal();
  factory ChatManager() => _instance;

  ChatManager._internal() {
    _initDefaultConversations();
  }

  final List<ChatConversationModel> _conversations = [];

  List<ChatConversationModel> get conversations =>
      List.unmodifiable(_conversations);

  int get totalUnreadCount =>
      _conversations.fold(0, (sum, item) => sum + item.unreadCount);

  void _initDefaultConversations() {
    _conversations.addAll([
      // 1. Toko Sayur Ibu Ida (Pernah membeli: true, unread: 1)
      const ChatConversationModel(
        id: 'chat_ibu_ida',
        storeName: 'Toko Sayur Ibu Ida',
        storeLocation: 'Caringin, Lampung',
        lastMessage:
            'Pesanan sayur dan kol siap diambil ya pak, karung sudah kami siapkan.',
        time: '10:14',
        unreadCount: 1,
        hasPurchased: true,
        icon: Icons.storefront_rounded,
        iconColor: Color(0xFF047857),
        iconBgColor: Color(0xFFDCFCE7),
      ),

      // 2. Toko Buah Ibu Rina (Pernah membeli: true, unread: 2)
      const ChatConversationModel(
        id: 'chat_ibu_rina',
        storeName: 'Toko Buah Ibu Rina',
        storeLocation: 'Kedaton, Bandar Lampung',
        lastMessage:
            'Pisang kepok matang masih tersedia 5 sisir, silakan diambil pagi ini ya.',
        time: '09:30',
        unreadCount: 2,
        hasPurchased: true,
        icon: Icons.eco_rounded,
        iconColor: Color(0xFFD97706),
        iconBgColor: Color(0xFFFEF3C7),
      ),

      // 3. Toko Sayur Mas Kipli (Pernah membeli: false, unread: 0)
      const ChatConversationModel(
        id: 'chat_mas_kipli',
        storeName: 'Toko Sayur Mas Kipli',
        storeLocation: 'Kemiling, Bandar Lampung',
        lastMessage:
            'Halo kak, apakah ampas tahu masih ready untuk diambil besok pagi?',
        time: 'Kemarin',
        unreadCount: 0,
        hasPurchased: false,
        icon: Icons.local_shipping_rounded,
        iconColor: Color(0xFF0284C7),
        iconBgColor: Color(0xFFE0F2FE),
      ),

      // 4. Toko Buah Makmur (Pernah membeli: true, unread: 0)
      const ChatConversationModel(
        id: 'chat_buah_makmur',
        storeName: 'Toko Buah Makmur',
        storeLocation: 'Way Halim, Bandar Lampung',
        lastMessage:
            'Terima kasih banyak sudah berbelanja pakan di Toko Buah Makmur!',
        time: '18 Mar',
        unreadCount: 0,
        hasPurchased: true,
        icon: Icons.shopping_basket_rounded,
        iconColor: Color(0xFF047857),
        iconBgColor: Color(0xFFDCFCE7),
      ),
    ]);
  }

  void markAsRead(String id) {
    final index = _conversations.indexWhere((c) => c.id == id);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index] =
          _conversations[index].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  void markAsReadByStoreName(String storeName) {
    final index = _conversations.indexWhere((c) => c.storeName == storeName);
    if (index != -1 && _conversations[index].unreadCount > 0) {
      _conversations[index] =
          _conversations[index].copyWith(unreadCount: 0);
      notifyListeners();
    }
  }

  List<ChatConversationModel> getFilteredConversations({
    String filter = 'Semua',
    String searchQuery = '',
  }) {
    final query = searchQuery.trim().toLowerCase();

    return _conversations.where((chat) {
      // 1. Filter Chip Filter
      if (filter == 'Belum dibaca' && !chat.isUnread) {
        return false;
      }
      if (filter == 'Pernah membeli' && !chat.hasPurchased) {
        return false;
      }

      // 2. Search Query Filter
      if (query.isNotEmpty) {
        final matchStore = chat.storeName.toLowerCase().contains(query);
        final matchMessage = chat.lastMessage.toLowerCase().contains(query);
        if (!matchStore && !matchMessage) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}

