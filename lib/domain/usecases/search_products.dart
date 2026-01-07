import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/entities/product.dart';
import 'package:product_browser_app/domain/repository/product_repository.dart';

/// Use case for searching products by query
class SearchProductsUseCase {
  final ProductRepository repository;

  SearchProductsUseCase({required this.repository});

  Future<Either<Failure, List<Product>>> call({
    required String query,
    int limit = 20,
  }) {
    return repository.searchProducts(query: query, limit: limit);
  }
}
