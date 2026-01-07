import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/entities/product.dart';
import 'package:product_browser_app/domain/usecases/get_categories.dart';
import 'package:product_browser_app/domain/usecases/get_products.dart';
import 'package:product_browser_app/domain/usecases/search_products.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_event.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_state.dart';

/// Bloc managing the product list state
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;

  ProductListBloc({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
    required this.getCategoriesUseCase,
  }) : super(const ProductListState()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
    on<SearchProducts>(_onSearchProducts);
    on<ClearSearch>(_onClearSearch);
    on<FilterByCategory>(_onFilterByCategory);
    on<Retry>(_onRetry);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, skip: 0));

    // Fetch categories
    await _loadCategories(emit);

    // Fetch products
    final result = await getProductsUseCase(limit: state.limit, skip: 0);

    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoading: false, error: mapFailureToMessage(failure)),
        );
      },
      (products) {
        emit(
          state.copyWith(
            isLoading: false,
            products: products,
            hasMore: products.length >= state.limit,
            skip: products.length,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true, error: null));

    final result = await getProductsUseCase(
      limit: state.limit,
      skip: state.skip,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            error: mapFailureToMessage(failure),
          ),
        );
      },
      (products) {
        emit(
          state.copyWith(
            isLoadingMore: false,
            products: [...state.products, ...products],
            hasMore: products.length >= state.limit,
            skip: state.skip + products.length,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, skip: 0));

    final result = await getProductsUseCase(limit: state.limit, skip: 0);

    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoading: false, error: mapFailureToMessage(failure)),
        );
      },
      (products) {
        emit(
          state.copyWith(
            isLoading: false,
            products: products,
            hasMore: products.length >= state.limit,
            skip: products.length,
            error: null,
          ),
        );
      },
    );
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const ClearSearch());
      return;
    }

    final selectedCategory = state.selectedCategory;

    emit(
      state.copyWith(isLoading: true, error: null, searchQuery: event.query),
    );

    final result = await searchProductsUseCase(query: event.query, limit: 100);

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(isLoading: false, error: mapFailureToMessage(failure)),
        );
      },
      (products) async {
        List<Product> displayProducts = products;
        List<Product> categoryFallbackProducts = [];

        // If search returned results, show them (regardless of category)
        if (products.isNotEmpty) {
          displayProducts = products;
        } else if (selectedCategory != null) {
          // Only if search returned NO results and a category is selected,
          // load all products from that category as fallback
          final allProductsResult = await getProductsUseCase(
            limit: 100,
            skip: 0,
          );
          allProductsResult.fold((failure) {}, (allProducts) {
            categoryFallbackProducts = allProducts
                .where((p) => p.category == selectedCategory)
                .toList();
          });
        }

        emit(
          state.copyWith(
            isLoading: false,
            products: displayProducts,
            categoryProducts: categoryFallbackProducts,
            hasMore: false,
            skip: displayProducts.length,
            error: null,
          ),
        );
      },
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<ProductListState> emit) {
    emit(state.copyWith(clearSearchQuery: true));
    if (state.selectedCategory != null) {
      add(FilterByCategory(category: state.selectedCategory));
    } else {
      add(const LoadProducts());
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductListState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        selectedCategory: event.category,
        clearSearchQuery: true,
        categoryProducts: [],
      ),
    );

    if (event.category == null) {
      add(const LoadProducts());
      return;
    }

    final result = await getProductsUseCase(limit: 100, skip: 0);

    result.fold(
      (failure) {
        emit(
          state.copyWith(isLoading: false, error: mapFailureToMessage(failure)),
        );
      },
      (products) {
        final filteredProducts = products
            .where((p) => p.category == event.category)
            .toList();

        emit(
          state.copyWith(
            isLoading: false,
            products: filteredProducts,
            categoryProducts: [],
            hasMore: false,
            skip: filteredProducts.length,
            error: null,
          ),
        );
      },
    );
  }

  void _onRetry(Retry event, Emitter<ProductListState> emit) {
    if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
      add(SearchProducts(query: state.searchQuery!));
    } else if (state.selectedCategory != null) {
      add(FilterByCategory(category: state.selectedCategory));
    } else {
      add(const LoadProducts());
    }
  }

  Future<void> _loadCategories(Emitter<ProductListState> emit) async {
    final result = await getCategoriesUseCase();
    result.fold(
      (failure) {}, // Silently fail for categories
      (categories) {
        emit(state.copyWith(categories: categories));
      },
    );
  }
}
