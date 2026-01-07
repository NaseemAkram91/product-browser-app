import 'package:equatable/equatable.dart';
import 'package:product_browser_app/domain/entities/product.dart';

/// State representing the product detail screen
class ProductDetailState extends Equatable {
  final Product? product;
  final bool isLoading;
  final String? error;

  const ProductDetailState({
    this.product,
    this.isLoading = false,
    this.error,
  });

  /// Creates a copy of this state with the given fields replaced
  ProductDetailState copyWith({
    Product? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [product, isLoading, error];
}
