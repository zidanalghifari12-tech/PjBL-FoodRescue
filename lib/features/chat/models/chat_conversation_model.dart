import 'package:flutter/material.dart';

class ChatConversationModel {
  final String id;
  final String storeName;
  final String? storeLocation;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool hasPurchased;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ChatConversationModel({
    required this.id,
    required this.storeName,
    this.storeLocation,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.hasPurchased = false,
    this.icon = Icons.storefront_rounded,
    this.iconColor = const Color(0xFF047857),
    this.iconBgColor = const Color(0xFFDCFCE7),
  });

  bool get isUnread => unreadCount > 0;

  ChatConversationModel copyWith({
    String? id,
    String? storeName,
    String? storeLocation,
    String? lastMessage,
    String? time,
    int? unreadCount,
    bool? hasPurchased,
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
  }) {
    return ChatConversationModel(
      id: id ?? this.id,
      storeName: storeName ?? this.storeName,
      storeLocation: storeLocation ?? this.storeLocation,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
      hasPurchased: hasPurchased ?? this.hasPurchased,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBgColor: iconBgColor ?? this.iconBgColor,
    );
  }
}

