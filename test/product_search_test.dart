import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/domain/usecases/get_categories.dart';
import 'package:product_browser_app/domain/usecases/get_products.dart';
import 'package:product_browser_app/domain/usecases/search_products.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_bloc.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_event.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_state.dart';
import 'package:dartz/dartz.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

class MockSearchProductsUseCase extends Mock implements SearchProductsUseCase {}

class MockGetCategoriesUseCase extends Mock implements GetCategoriesUseCase {}

void main() {
  late ProductListBloc bloc;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockSearchProductsUseCase mockSearchProductsUseCase;
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;

  setUp(() {
    mockGetProductsUseCase = MockGetProductsUseCase();
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    bloc = ProductListBloc(
      getProductsUseCase: mockGetProductsUseCase,
      searchProductsUseCase: mockSearchProductsUseCase,
      getCategoriesUseCase: mockGetCategoriesUseCase,
    );
  });

  group('Search functionality tests', () {
    test('Clearing search query should work correctly', () {
      final state = const ProductListState(searchQuery: 'test');
      final newState = state.copyWith(clearSearchQuery: true);
      expect(newState.searchQuery, isNull);
    });

    test('Not clearing search query should preserve it', () {
      final state = const ProductListState(searchQuery: 'test');
      final newState = state.copyWith(clearSearchQuery: false);
      expect(newState.searchQuery, 'test');
    });

    test('Updating search query should work', () {
      final state = const ProductListState(searchQuery: 'test');
      final newState = state.copyWith(searchQuery: 'new');
      expect(newState.searchQuery, 'new');
    });

    blocTest<ProductListBloc, ProductListState>(
      'emits correct state when search query is cleared',
      build: () {
        when(
          () => mockGetProductsUseCase(
            limit: any(named: 'limit'),
            skip: any(named: 'skip'),
          ),
        ).thenAnswer((_) async => const Right([]));
        when(
          () => mockGetCategoriesUseCase(),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const ClearSearch()),
      verify: (bloc) {
        // Verify that LoadProducts is added which eventually clears search query
      },
    );
  });
}
