import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_bloc.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_event.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_state.dart';
import 'package:product_browser_app/presentation/features/product_list/product_list_screen.dart';

class MockProductListBloc extends MockBloc<ProductListEvent, ProductListState>
    implements ProductListBloc {}

void main() {
  late MockProductListBloc mockBloc;

  setUp(() {
    mockBloc = MockProductListBloc();
    final getIt = GetIt.instance;
    if (getIt.isRegistered<ProductListBloc>()) {
      getIt.unregister<ProductListBloc>();
    }
    getIt.registerFactory<ProductListBloc>(() => mockBloc);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('Search query updates when user types', (tester) async {
    when(() => mockBloc.state).thenReturn(const ProductListState());

    await tester.pumpWidget(MaterialApp(home: ProductListScreen()));

    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();

    verify(() => mockBloc.add(const SearchProducts(query: 'test'))).called(1);
  });

  testWidgets(
    'Search query does not clear when state updates but query is not null',
    (tester) async {
      // Initial state with a search query
      when(
        () => mockBloc.state,
      ).thenReturn(const ProductListState(searchQuery: 'test'));

      // Create the stream controller to simulate state changes
      final streamController = StreamController<ProductListState>();
      whenListen(
        mockBloc,
        streamController.stream,
        initialState: const ProductListState(searchQuery: 'test'),
      );

      await tester.pumpWidget(MaterialApp(home: ProductListScreen()));

      // Manually enter text since the controller doesn't listen to the state for initial value
      // The screen only CLEARS when state tells it to, it doesn't SET from state
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      // Verify initial text matches what we typed
      expect(find.text('test'), findsOneWidget);

      // Let's simluate typing 't'
      await tester.enterText(find.byType(TextField), 't');

      // Now simulate a loading state coming from Bloc (which previously caused the clear)
      streamController.add(
        const ProductListState(isLoading: true, searchQuery: 't'),
      );
      await tester.pump();

      // Text should STILL be 't'
      expect(find.text('t'), findsOneWidget);
    },
  );

  testWidgets('Search query clears only when state explicitly clears query', (
    tester,
  ) async {
    // Simulate transition from query 'test' -> null
    final streamController = StreamController<ProductListState>();
    when(
      () => mockBloc.state,
    ).thenReturn(const ProductListState(searchQuery: 'test'));
    whenListen(
      mockBloc,
      streamController.stream,
      initialState: const ProductListState(searchQuery: 'test'),
    );

    await tester.pumpWidget(MaterialApp(home: ProductListScreen()));

    // Manually set text to match "current state"
    await tester.enterText(find.byType(TextField), 'test');
    expect(find.text('test'), findsOneWidget);

    // Emit new state with null query
    streamController.add(const ProductListState(searchQuery: null));
    await tester.pump();

    // NOW it should be empty
    expect(find.text('test'), findsNothing);
  });

  testWidgets(
    'Screen wraps content in GestureDetector for keyboard dismissal',
    (tester) async {
      when(() => mockBloc.state).thenReturn(const ProductListState());

      await tester.pumpWidget(MaterialApp(home: ProductListScreen()));

      // Find the GestureDetector that wraps the Scaffold
      // The structure is BlocProvider -> GestureDetector -> Scaffold
      // We look for a GestureDetector that contains the Scaffold
      final detector = find.ancestor(
        of: find.byType(Scaffold),
        matching: find.byType(GestureDetector),
      );

      expect(detector, findsOneWidget);

      // Validate it has an onTap callback
      final GestureDetector widget = tester.widget(detector);
      expect(widget.onTap, isNotNull);
    },
  );
}
