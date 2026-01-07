import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_browser_app/core/utils/price_formatter.dart';
import 'package:product_browser_app/domain/entities/product.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable card widget for displaying product information
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showCategoryMismatch;
  final String? selectedCategory;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showCategoryMismatch = false,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMismatch = showCategoryMismatch &&
        selectedCategory != null &&
        product.category != selectedCategory;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                        highlightColor: isDark
                            ? Colors.grey[700]!
                            : Colors.grey[100]!,
                        child: Container(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.price.toPriceString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isMismatch)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Not in $selectedCategory',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onError,
                          fontSize: 10,
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
