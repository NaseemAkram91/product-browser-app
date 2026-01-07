import 'package:equatable/equatable.dart';
import 'package:product_browser_app/domain/entities/product.dart';

/// Base class for all product detail events
abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load a product by ID
class LoadProductDetail extends ProductDetailEvent {
  final int productId;

  const LoadProductDetail({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to set product detail directly (avoiding API call)
class SetProductDetail extends ProductDetailEvent {
  final Product product;

  const SetProductDetail({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Event to retry loading the product
class RetryLoadProduct extends ProductDetailEvent {
  const RetryLoadProduct();
}
