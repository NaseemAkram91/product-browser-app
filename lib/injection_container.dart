import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:product_browser_app/data/datasources/product_remote_datasource.dart';
import 'package:product_browser_app/data/repository/product_repository_impl.dart';
import 'package:product_browser_app/domain/repository/product_repository.dart';
import 'package:product_browser_app/domain/usecases/get_categories.dart';
import 'package:product_browser_app/domain/usecases/get_product_by_id.dart';
import 'package:product_browser_app/domain/usecases/get_products.dart';
import 'package:product_browser_app/domain/usecases/search_products.dart';
import 'package:product_browser_app/presentation/features/product_detail/bloc/product_detail_bloc.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_bloc.dart';

/// Service locator for dependency injection
final GetIt sl = GetIt.instance;

/// Initializes all dependencies
Future<void> initDependencies() async {
  // Core - Configure Dio with better settings
  sl.registerLazySingleton(
    () =>
        Dio(
            BaseOptions(
              baseUrl: 'https://dummyjson.com',
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
              contentType: 'application/json',
              responseType: ResponseType.json,
            ),
          )
          ..interceptors.add(
            LogInterceptor(
              request: true,
              requestHeader: true,
              requestBody: true,
              responseHeader: true,
              responseBody: true,
              error: true,
            ),
          ),
  );

  // Data sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(repository: sl()));

  // Blocs
  sl.registerFactory(
    () => ProductListBloc(
      getProductsUseCase: sl(),
      searchProductsUseCase: sl(),
      getCategoriesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductDetailBloc(getProductByIdUseCase: sl()),
  );
}

/// Resets all registered dependencies (useful for testing)
void resetDependencies() {
  sl.reset();
}
