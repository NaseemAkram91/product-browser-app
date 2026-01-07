import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/entities/product.dart';

/// Abstract repository interface for product operations
abstract class ProductRepository {
  /// Fetches a paginated list of products
  Future<Either<Failure, List<Product>>> getProducts({
    int limit,
    int skip,
  });

  /// Searches products by query
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int limit,
  });

  /// Fetches a single product by ID
  Future<Either<Failure, Product>> getProductById(int id);

  /// Fetches all product categories
  Future<Either<Failure, List<String>>> getCategories();

  /// Fetches products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String category,
    int limit,
  });
}
