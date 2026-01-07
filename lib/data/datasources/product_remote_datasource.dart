import 'package:dio/dio.dart';
import 'package:product_browser_app/core/constants/api_constants.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/data/models/product_model.dart';

/// Remote data source for fetching product data from the DummyJSON API
class ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSource({required Dio dio}) : _dio = dio;

  /// Fetches all products with pagination
  ///
  /// [limit] - Number of products to fetch per page
  /// [skip] - Number of products to skip (for pagination)
  Future<ProductsResponse> getProducts({
    int limit = ApiConstants.defaultLimit,
    int skip = ApiConstants.defaultSkip,
  }) async {
    try {
      final response = await _dio.get(
        '/products',
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      return ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      String errorMsg = 'Network error';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Receive timeout';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMsg = 'Send timeout';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMsg = 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        errorMsg = 'Request cancelled';
      } else if (e.type == DioExceptionType.unknown) {
        errorMsg = e.message ?? 'Unknown network error';
      }
      throw NetworkFailure(message: errorMsg);
    } on FormatException catch (e) {
      throw ParsingFailure(message: 'Failed to parse response: ${e.message}');
    }
  }

  /// Searches products by query
  ///
  /// [query] - Search query string
  /// [limit] - Number of products to fetch
  Future<ProductsResponse> searchProducts({
    required String query,
    int limit = ApiConstants.defaultLimit,
  }) async {
    try {
      final response = await _dio.get(
        '/products/search',
        queryParameters: {
          'q': query,
          'limit': limit,
        },
      );

      return ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      String errorMsg = 'Network error';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Receive timeout';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMsg = 'Send timeout';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMsg = 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        errorMsg = 'Request cancelled';
      } else if (e.type == DioExceptionType.unknown) {
        errorMsg = e.message ?? 'Unknown network error';
      }
      throw NetworkFailure(message: errorMsg);
    } on FormatException catch (e) {
      throw ParsingFailure(message: 'Failed to parse response: ${e.message}');
    }
  }

  /// Fetches a single product by ID
  ///
  /// [id] - Product ID
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        throw ServerFailure(message: 'Product not found');
      } else {
        throw ServerFailure(
          message: 'Failed to fetch product: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMsg = 'Network error';
      if (e.type == DioExceptionType.badResponse) {
        errorMsg = 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.unknown) {
        errorMsg = e.message ?? 'Unknown network error';
      }
      throw NetworkFailure(message: errorMsg);
    } on FormatException catch (e) {
      throw ParsingFailure(message: 'Failed to parse response: ${e.message}');
    }
  }

  /// Fetches all product categories
  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');

      if (response.statusCode == 200) {
        return CategoriesResponse.fromJson(response.data as List).categories;
      } else {
        throw ServerFailure(
          message: 'Failed to fetch categories: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      String errorMsg = 'Network error';
      if (e.type == DioExceptionType.badResponse) {
        errorMsg = 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.unknown) {
        errorMsg = e.message ?? 'Unknown network error';
      }
      throw NetworkFailure(message: errorMsg);
    } on FormatException catch (e) {
      throw ParsingFailure(message: 'Failed to parse response: ${e.message}');
    }
  }

  /// Fetches products by category
  ///
  /// [category] - Category name
  /// [limit] - Number of products to fetch
  Future<ProductsResponse> getProductsByCategory({
    required String category,
    int limit = ApiConstants.defaultLimit,
  }) async {
    try {
      final response = await _dio.get(
        '/products/category/$category',
        queryParameters: {'limit': limit},
      );

      return ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      String errorMsg = 'Network error';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMsg = 'Receive timeout';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errorMsg = 'Send timeout';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMsg = 'Server error: ${e.response?.statusCode}';
      } else if (e.type == DioExceptionType.cancel) {
        errorMsg = 'Request cancelled';
      } else if (e.type == DioExceptionType.unknown) {
        errorMsg = e.message ?? 'Unknown network error';
      }
      throw NetworkFailure(message: errorMsg);
    } on FormatException catch (e) {
      throw ParsingFailure(message: 'Failed to parse response: ${e.message}');
    }
  }
}
