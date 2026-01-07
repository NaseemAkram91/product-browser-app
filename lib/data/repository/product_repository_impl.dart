import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/data/datasources/product_remote_datasource.dart';
import 'package:product_browser_app/data/models/product_model.dart';
import 'package:product_browser_app/domain/entities/product.dart' as entity;
import 'package:product_browser_app/domain/repository/product_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of the ProductRepository
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<entity.Product>>> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await remoteDataSource.getProducts(
        limit: limit,
        skip: skip,
      );
      return Right(response.products.map(_convertToEntity).toList());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<entity.Product>>> searchProducts({
    required String query,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.searchProducts(
        query: query,
        limit: limit,
      );
      return Right(response.products.map(_convertToEntity).toList());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, entity.Product>> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(_convertToEntity(product));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<entity.Product>>> getProductsByCategory({
    required String category,
    int limit = 20,
  }) async {
    try {
      final response = await remoteDataSource.getProductsByCategory(
        category: category,
        limit: limit,
      );
      return Right(response.products.map(_convertToEntity).toList());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  entity.Product _convertToEntity(ProductModel model) {
    return entity.Product(
      id: model.id,
      title: model.title,
      description: model.description,
      category: model.category,
      price: model.price,
      discountPercentage: model.discountPercentage,
      rating: model.rating,
      stock: model.stock,
      tags: model.tags,
      brand: model.brand,
      sku: model.sku,
      weight: model.weight,
      dimensions: entity.Dimensions(
        width: model.dimensions.width,
        height: model.dimensions.height,
        depth: model.dimensions.depth,
      ),
      warrantyInformation: model.warrantyInformation,
      shippingInformation: model.shippingInformation,
      availabilityStatus: model.availabilityStatus,
      reviews: model.reviews
          .map(
            (r) => entity.Review(
              rating: r.rating,
              comment: r.comment,
              date: r.date,
              reviewerName: r.reviewerName,
              reviewerEmail: r.reviewerEmail,
            ),
          )
          .toList(),
      returnPolicy: model.returnPolicy,
      minimumOrderQuantity: model.minimumOrderQuantity,
      meta: entity.Meta(
        createdAt: model.meta.createdAt,
        updatedAt: model.meta.updatedAt,
        barcode: model.meta.barcode,
        qrCode: model.meta.qrCode,
      ),
      images: model.images,
      thumbnail: model.thumbnail,
    );
  }
}
