import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/utils/price_formatter.dart';
import 'package:product_browser_app/domain/entities/product.dart';
import 'package:product_browser_app/injection_container.dart';
import 'package:product_browser_app/presentation/common/widgets/error_widget.dart';
import 'package:product_browser_app/presentation/common/widgets/loading_indicator.dart';
import 'package:product_browser_app/presentation/features/product_detail/bloc/product_detail_bloc.dart';
import 'package:product_browser_app/presentation/features/product_detail/bloc/product_detail_event.dart';
import 'package:product_browser_app/presentation/features/product_detail/bloc/product_detail_state.dart';

/// Product detail screen displaying full product information
class ProductDetailScreen extends StatelessWidget {
  final int productId;
  final Product? product;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.product,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = sl<ProductDetailBloc>();
        if (product != null) {
          bloc.add(SetProductDetail(product: product!));
        } else {
          bloc.add(LoadProductDetail(productId: productId));
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!)));
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingIndicator(message: 'Loading product...');
            }

            if (state.error != null && state.product == null) {
              return ErrorDisplay(
                message: state.error!,
                onRetry: () =>
                    context.read<ProductDetailBloc>().add(RetryLoadProduct()),
              );
            }

            if (state.product == null) {
              return const ErrorDisplay(message: 'Product not found');
            }

            final product = state.product!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: CachedNetworkImage(
                      imageUrl: product.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 64),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            product.category.capitalize(),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Title
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),

                        // Brand
                        Text(
                          'by ${product.brand}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                        const SizedBox(height: 16),

                        // Price
                        Row(
                          children: [
                            Text(
                              product.price.toPriceString(),
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            if (product.discountPercentage != 0) ...[
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '-${product.discountPercentage.toStringAsFixed(1)}%',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Rating
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 24,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (product.stock > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                '(${product.stock} in stock)',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                    ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),

                        // Additional Images
                        if (product.images.isNotEmpty) ...[
                          Text(
                            'More Images',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.images.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: product.images[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                        child:
                                            CircularProgressIndicator.adaptive(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),
                        // Additional details (Dimensions, Warranty, Return Policy)
                        Text(
                          'Additional Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow(context, 'Warranty', product.warrantyInformation),
                        _buildDetailRow(context, 'Shipping', product.shippingInformation),
                        _buildDetailRow(context, 'Return Policy', product.returnPolicy),

                        const SizedBox(height: 24),

                        // Reviews
                        if (product.reviews.isNotEmpty) ...[
                          Text(
                            'Reviews',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: product.reviews.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final review = product.reviews[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  children: [
                                    Text(review.reviewerName),
                                    const Spacer(),
                                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                                    Text(' ${review.rating}'),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(review.comment),
                                    Text(
                                      review.date.split('T')[0],
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

extension on String {
  String capitalize() {
    return split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
