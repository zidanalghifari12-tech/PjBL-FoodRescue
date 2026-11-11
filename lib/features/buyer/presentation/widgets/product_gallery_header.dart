import 'package:flutter/material.dart';
import 'package:foodrescue/core/theme/app_theme.dart';
import 'package:foodrescue/features/home/models/feed_product_model.dart';

class ProductGalleryHeader extends StatefulWidget {
  final FeedProduct product;

  const ProductGalleryHeader({
    super.key,
    required this.product,
  });

  @override
  State<ProductGalleryHeader> createState() => _ProductGalleryHeaderState();
}

class _ProductGalleryHeaderState extends State<ProductGalleryHeader> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.product.photos;
    final totalPhotos = photos.length;
    final isAvailable = widget.product.status == 'Tersedia';

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Stack(
        children: [
          // Photo Swiper
          PageView.builder(
            controller: _pageController,
            itemCount: totalPhotos,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                color: widget.product.placeholderColor,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Subtle stylized gradient & illustration
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.product.placeholderColor,
                            Colors.black.withValues(alpha: 0.25),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.product.placeholderIcon,
                            size: 72,
                            color: AppTheme.primaryColor.withValues(alpha: 0.6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            photos[index],
                            style: TextStyle(
                              fontFamily: AppTheme.headingFontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.neutralColor.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Top Left Status Badge (Segera / Tersedia)
          Positioned(
            top: 14,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isAvailable
                    ? AppTheme.primaryColor
                    : const Color(0xFFB45309), // Amber-700
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.product.status,
                    style: const TextStyle(
                      fontFamily: AppTheme.headingFontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Right Remaining Time Badge
          Positioned(
            top: 14,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    widget.product.remainingTime,
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Left: Foto Batch Indicator Badge
          Positioned(
            bottom: 14,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.photo_library_outlined,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${_currentPage + 1}/$totalPhotos Foto Batch',
                    style: const TextStyle(
                      fontFamily: AppTheme.bodyFontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Right: Dots Page Indicator
          Positioned(
            bottom: 18,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(totalPhotos, (index) {
                final isActive = index == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isActive ? 18 : 6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.secondaryColor
                        : Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

