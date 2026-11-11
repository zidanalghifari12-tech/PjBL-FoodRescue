import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback onFilterTap;
  final bool hasActiveFilter;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    required this.onFilterTap,
    this.hasActiveFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Search Input Field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: const TextStyle(
                  fontFamily: AppTheme.bodyFontFamily,
                  fontSize: 13,
                  color: AppTheme.neutralColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari ampas tahu, sisa sayur, roti afkir',
                  hintStyle: const TextStyle(
                    fontFamily: AppTheme.bodyFontFamily,
                    fontSize: 12.5,
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.primaryColor,
                    size: 22,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                          onPressed: onClear,
                        )
                      : null,
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Filter Button
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasActiveFilter
                    ? const Color(0xFFECFDF5)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: hasActiveFilter
                      ? AppTheme.primaryColor
                      : const Color(0xFFE2E8F0),
                  width: hasActiveFilter ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: hasActiveFilter
                        ? AppTheme.primaryColor
                        : AppTheme.neutralColor,
                    size: 22,
                  ),
                  if (hasActiveFilter)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

