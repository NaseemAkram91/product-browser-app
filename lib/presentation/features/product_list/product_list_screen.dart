import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/injection_container.dart';
import 'package:product_browser_app/presentation/common/widgets/error_widget.dart';
import 'package:product_browser_app/presentation/common/widgets/loading_indicator.dart';
import 'package:product_browser_app/presentation/common/widgets/product_card.dart';
import 'package:product_browser_app/presentation/common/widgets/shimmer_loading.dart';
import 'package:product_browser_app/presentation/features/product_detail/product_detail_screen.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_bloc.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_event.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_state.dart';

/// Static list of categories from dummyjson API
const List<Map<String, String>> _staticCategories = [
  {'slug': 'beauty', 'name': 'Beauty'},
  {'slug': 'fragrances', 'name': 'Fragrances'},
  {'slug': 'furniture', 'name': 'Furniture'},
  {'slug': 'groceries', 'name': 'Groceries'},
  {'slug': 'home-decoration', 'name': 'Home Decoration'},
  {'slug': 'kitchen-accessories', 'name': 'Kitchen Accessories'},
  {'slug': 'laptops', 'name': 'Laptops'},
  {'slug': 'mens-shirts', 'name': 'Mens Shirts'},
  {'slug': 'mens-shoes', 'name': 'Mens Shoes'},
  {'slug': 'mens-watches', 'name': 'Mens Watches'},
  {'slug': 'mobile-accessories', 'name': 'Mobile Accessories'},
  {'slug': 'motorcycle', 'name': 'Motorcycle'},
  {'slug': 'skin-care', 'name': 'Skin Care'},
  {'slug': 'smartphones', 'name': 'Smartphones'},
  {'slug': 'sports-accessories', 'name': 'Sports Accessories'},
  {'slug': 'sunglasses', 'name': 'Sunglasses'},
  {'slug': 'tablets', 'name': 'Tablets'},
  {'slug': 'tops', 'name': 'Tops'},
  {'slug': 'vehicle', 'name': 'Vehicle'},
  {'slug': 'womens-bags', 'name': 'Womens Bags'},
  {'slug': 'womens-dresses', 'name': 'Womens Dresses'},
  {'slug': 'womens-jewellery', 'name': 'Womens Jewellery'},
  {'slug': 'womens-shoes', 'name': 'Womens Shoes'},
  {'slug': 'womens-watches', 'name': 'Womens Watches'},
];

/// Product list screen displaying paginated products with search and filter
class ProductListScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;

  const ProductListScreen({super.key, this.onToggleTheme});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedCategory;
  ProductListBloc? _bloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _bloc?.add(const LoadMoreProducts());
    }
  }

  void _onSearchChanged(String query) {
    _bloc?.add(SearchProducts(query: query));
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _bloc?.add(FilterByCategory(category: category));
  }

  String _getCategoryName(String categorySlug) {
    final category = _staticCategories.firstWhere(
      (cat) => cat['slug'] == categorySlug,
      orElse: () => {'slug': categorySlug, 'name': categorySlug},
    );
    return category['name']!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = sl<ProductListBloc>()..add(const LoadProducts());
        return _bloc!;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: widget.onToggleTheme,
            ),
          ],
        ),
        body: Column(
          children: [
            _buildSearchBar(context),
            _buildCategoryFilter(context),
            Expanded(
              child: BlocConsumer<ProductListBloc, ProductListState>(
                listener: (context, state) {
                  if (state.searchQuery == null) {
                    _searchController.clear();
                  }
                },
                builder: (context, state) {
                  // Show shimmer during initial load or any loading state
                  if (state.isInitial || state.isLoading) {
                    return const ProductGridShimmer();
                  }

                  if (state.error != null && state.products.isEmpty) {
                    return ErrorDisplay(
                      message: state.error!,
                      onRetry: () => _bloc?.add(const Retry()),
                    );
                  }

                  if (state.products.isEmpty) {
                    // If search returned empty but category products exist, show them
                    if (state.categoryProducts.isNotEmpty &&
                        state.searchQuery != null &&
                        state.selectedCategory != null) {
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondaryContainer,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No results for "${state.searchQuery}" in ${_getCategoryName(state.selectedCategory!)}. Showing all ${_getCategoryName(state.selectedCategory!)} products:',
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                              itemCount: state.categoryProducts.length,
                              itemBuilder: (context, index) {
                                final product = state.categoryProducts[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailScreen(
                                          productId: product.id,
                                          product: product,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }

                    return const EmptyState(
                      message: 'No products found',
                      icon: Icons.search_off,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _bloc?.add(const RefreshProducts());
                      // Wait for the refresh to complete
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final product = state.products[index];
                              return ProductCard(
                                product: product,
                                showCategoryMismatch:
                                    state.selectedCategory != null &&
                                    state.searchQuery != null,
                                selectedCategory: state.selectedCategory,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                        productId: product.id,
                                        product: product,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }, childCount: state.products.length),
                          ),
                        ),
                        if (state.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: LoadingMoreIndicator(),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _searchController,
        builder: (context, value, child) {
          return TextField(
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _bloc?.add(const ClearSearch());
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: _onSearchChanged,
          );
        },
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          FilterChip(
            label: const Text('All'),
            selected: _selectedCategory == null,
            onSelected: (_) => _onCategorySelected(null),
          ),
          const SizedBox(width: 8),
          ..._staticCategories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category['name']!),
                selected: _selectedCategory == category['slug'],
                onSelected: (_) => _onCategorySelected(category['slug']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
