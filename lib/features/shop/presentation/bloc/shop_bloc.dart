import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/shop.dart';
import '../../domain/usecases/get_shop_detail_usecase.dart';
import '../../domain/usecases/get_shops_usecase.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc({
    required GetShopsUseCase getShopsUseCase,
    required GetShopDetailUseCase getShopDetailUseCase,
  })  : _getShopsUseCase = getShopsUseCase,
        _getShopDetailUseCase = getShopDetailUseCase,
        super(const ShopState()) {
    on<ShopListRequested>(_onListRequested);
    on<ShopDetailRequested>(_onDetailRequested);
    on<ShopCategoryFilterChanged>(_onCategoryFilterChanged);
  }

  final GetShopsUseCase _getShopsUseCase;
  final GetShopDetailUseCase _getShopDetailUseCase;

  Future<void> _onListRequested(
    ShopListRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(listStatus: ShopListStatus.loading, listError: null));
    final result = await _getShopsUseCase(GetShopsParams(
      category: event.category ?? state.categoryFilter,
    ));
    result.fold(
      (f) => emit(state.copyWith(
          listStatus: ShopListStatus.failure, listError: f.message)),
      (shops) => emit(state.copyWith(
          listStatus: ShopListStatus.success, shops: shops)),
    );
  }

  Future<void> _onDetailRequested(
    ShopDetailRequested event,
    Emitter<ShopState> emit,
  ) async {
    emit(state.copyWith(
        detailStatus: ShopDetailStatus.loading,
        detailError: null,
        selectedShop: null));
    final result =
        await _getShopDetailUseCase(GetShopDetailParams(event.shopId));
    result.fold(
      (f) => emit(state.copyWith(
          detailStatus: ShopDetailStatus.failure, detailError: f.message)),
      (shop) => emit(state.copyWith(
          detailStatus: ShopDetailStatus.success, selectedShop: shop)),
    );
  }

  void _onCategoryFilterChanged(
    ShopCategoryFilterChanged event,
    Emitter<ShopState> emit,
  ) {
    emit(state.copyWith(categoryFilter: event.category));
  }
}
