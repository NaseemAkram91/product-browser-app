import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/main.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_bloc.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_event.dart';
import 'package:product_browser_app/presentation/features/product_list/bloc/product_list_state.dart';

class MockProductListBloc extends MockBloc<ProductListEvent, ProductListState>
    implements ProductListBloc {}

void main() {
  late MockProductListBloc mockProductListBloc;

  setUp(() {
    mockProductListBloc = MockProductListBloc();
    final sl = GetIt.instance;
    if (sl.isRegistered<ProductListBloc>()) {
      sl.unregister<ProductListBloc>();
    }
    sl.registerFactory<ProductListBloc>(() => mockProductListBloc);

    when(() => mockProductListBloc.state).thenReturn(const ProductListState());
  });

  testWidgets('App loads and shows Products title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Products'), findsOneWidget);
  });
}
