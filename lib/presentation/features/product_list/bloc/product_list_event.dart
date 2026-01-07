import 'package:equatable/equatable.dart';

/// Base class for all product list events
abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load initial products
class LoadProducts extends ProductListEvent {
  const LoadProducts();
}

/// Event to load more products (pagination)
class LoadMoreProducts extends ProductListEvent {
  const LoadMoreProducts();
}

/// Event to refresh products (pull-to-refresh)
class RefreshProducts extends ProductListEvent {
  const RefreshProducts();
}

/// Event to search products
class SearchProducts extends ProductListEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to clear search and show all products
class ClearSearch extends ProductListEvent {
  const ClearSearch();
}

/// Event to filter products by category
class FilterByCategory extends ProductListEvent {
  final String? category;

  const FilterByCategory({this.category});

  @override
  List<Object?> get props => [category];
}

/// Event to retry after an error
class Retry extends ProductListEvent {
  const Retry();
}
