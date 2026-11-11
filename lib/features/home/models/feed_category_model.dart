import 'package:flutter/material.dart';

class FeedCategory {
  final String id;
  final String name;
  final String weight;
  final IconData icon;
  final Color color;
  final String? imageUrl;

  const FeedCategory({
    required this.id,
    required this.name,
    required this.weight,
    required this.icon,
    required this.color,
    this.imageUrl,
  });
}

