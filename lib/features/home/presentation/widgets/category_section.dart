import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_category_model.dart';

class CategorySection extends StatelessWidget {
  final List<FeedCategory> categories;
  final String? selectedCategory;
  final ValueChanged<String>? onCategorySelected;
  final VoidCallback? onSeeAllTap;

  const CategorySection({
    super.key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kategori Pakan',
                style: TextStyle(
                  fontFamily: AppTheme.headingFontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neutralColor,
                ),
              ),
              InkWell(
                onTap: onSeeAllTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Menampilkan semua kategori pakan...'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                child: Row(
                  children: const [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Horizontal Category List
        SizedBox(
          height: 104,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = categories[index];
              final isSelected = selectedCategory == item.name;

              return InkWell(
                onTap: () {
                  onCategorySelected?.call(item.name);
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Circular Category Container with Weight Badge
                    Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.color.withValues(alpha: 0.15),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : const Color(0xFF10B981).withValues(alpha: 0.7),
                              width: isSelected ? 2.2 : 1.2,
                            ),
                          ),
                          child: Icon(
                            item.icon,
                            color: item.color,
                            size: 28,
                          ),
                        ),
                        // Weight Badge Pill
                        Positioned(
                          bottom: -3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065F46),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              item.weight,
                              style: const TextStyle(
                                fontFamily: AppTheme.bodyFontFamily,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Category Name
                    Text(
                      item.name,
                      style: TextStyle(
                        fontFamily: AppTheme.headingFontFamily,
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.neutralColor,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

