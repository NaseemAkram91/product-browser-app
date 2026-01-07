import 'package:dartz/dartz.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/repository/product_repository.dart';

/// Use case for fetching product categories
class GetCategoriesUseCase {
  final ProductRepository repository;

  GetCategoriesUseCase({required this.repository});

  Future<Either<Failure, List<String>>> call() {
    return repository.getCategories();
  }
}
