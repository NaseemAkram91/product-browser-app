import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/entities/product.dart';
import 'package:product_browser_app/domain/repository/product_repository.dart';

/// Use case for fetching a paginated list of products
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<Either<Failure, List<Product>>> call({
    int limit = 20,
    int skip = 0,
  }) {
    return repository.getProducts(limit: limit, skip: skip);
  }
}
