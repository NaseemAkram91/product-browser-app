import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_browser_app/core/error/failure.dart';
import 'package:product_browser_app/domain/usecases/get_product_by_id.dart';
import 'package:product_browser_app/presentation/features/product_detail/bloc/product_detail_event.dart';
import 'package:product_browser_app/presentation/features/product_detail/bloc/product_detail_state.dart';

/// Bloc managing the product detail state
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailBloc({required this.getProductByIdUseCase})
      : super(const ProductDetailState()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<SetProductDetail>(_onSetProductDetail);
    on<RetryLoadProduct>(_onRetryLoadProduct);
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getProductByIdUseCase(event.productId);

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          error: mapFailureToMessage(failure),
        ));
      },
      (product) {
        emit(state.copyWith(
          isLoading: false,
          product: product,
          error: null,
        ));
      },
    );
  }

  void _onSetProductDetail(
    SetProductDetail event,
    Emitter<ProductDetailState> emit,
  ) {
    emit(state.copyWith(
      isLoading: false,
      product: event.product,
      error: null,
    ));
  }

  Future<void> _onRetryLoadProduct(
    RetryLoadProduct event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state.product != null) {
      add(LoadProductDetail(productId: state.product!.id));
    }
  }
}
