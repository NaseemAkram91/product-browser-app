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

  testWidgets('Keyboard dismisses on tap outside', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const ProductListState());

    await tester.pumpWidget(const MaterialApp(home: ProductListScreen()));

    // Find the TextField and give it focus
    await tester.tap(find.byType(TextField));
    await tester.pump();

    // Tap outside (on the AppBar title)
    await tester.tap(find.text('Products'));
    await tester.pump();

    // Verification: If the unfocus() was called, the primary focus should not be on any text field
    final primaryFocus = FocusManager.instance.primaryFocus;
    expect(primaryFocus?.context?.widget is! EditableText, isTrue);
  });
}
