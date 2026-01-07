import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/entities/product.dart';
import 'package:product_browser_app/domain/repository/product_repository.dart';

/// Use case for fetching a single product by ID
class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase({required this.repository});

  Future<Either<Failure, Product>> call(int id) {
    return repository.getProductById(id);
  }
}
