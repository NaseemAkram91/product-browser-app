import 'package:equatable/equatable.dart';
import 'package:product_browser_app/domain/entities/product.dart';

/// State representing the product list screen
class ProductListState extends Equatable {
  final List<Product> products;
  final List<Product> categoryProducts;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String? searchQuery;
  final String? selectedCategory;
  final List<String> categories;
  final bool hasMore;
  final int skip;
  final int limit;

  const ProductListState({
    this.products = const [],
    this.categoryProducts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery,
    this.selectedCategory,
    this.categories = const [],
    this.hasMore = true,
    this.skip = 0,
    this.limit = 20,
  });

  /// Creates a copy of this state with the given fields replaced
  ProductListState copyWith({
    List<Product>? products,
    List<Product>? categoryProducts,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    bool clearSearchQuery = false,
    String? selectedCategory,
    List<String>? categories,
    bool? hasMore,
    int? skip,
    int? limit,
  }) {
    return ProductListState(
      products: products ?? this.products,
      categoryProducts: categoryProducts ?? this.categoryProducts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
    products,
    categoryProducts,
    isLoading,
    isLoadingMore,
    error,
    searchQuery,
    selectedCategory,
    categories,
    hasMore,
    skip,
    limit,
  ];

  /// Returns true if we're in a loading or initial state
  bool get isInitial => isLoading && products.isEmpty;

  /// Returns true if we're refreshing
  bool get isRefreshing => isLoading && products.isNotEmpty;

  /// Returns true if we're loading more
  bool get isLoadingAdditional => isLoadingMore;
}
