import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shop/domain/entities/product.dart';
import '../../data/models/cart_item.dart';
import '../../data/models/cart_state.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._prefs) : super(const CartState()) {
    on<CartLoadRequested>(_onLoadRequested);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartQuantityUpdated>(_onQuantityUpdated);
    on<CartCleared>(_onCleared);
    add(const CartLoadRequested());
  }

  final SharedPreferences _prefs;
  static const String _storageKey = 'cart_state';

  Future<void> _onLoadRequested(CartLoadRequested event, Emitter<CartState> emit) async {
    emit(state.copyWith(status: CartStatus.loading, error: null));
    try {
      final jsonString = _prefs.getString(_storageKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        final cartModel = CartStateModel.fromJson(json);
        emit(state.copyWith(status: CartStatus.success, items: cartModel.items.cast<CartItemModel>()));
      } else {
        emit(state.copyWith(status: CartStatus.success, items: const []));
      }
    } catch (e) {
      emit(state.copyWith(status: CartStatus.failure, error: e.toString(), items: const []));
    }
  }

  Future<void> _onItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((item) => item.product.id == event.product.id);

    if (index >= 0) {
      final existing = items[index];
      items[index] = CartItemModel(product: existing.product, quantity: existing.quantity + event.quantity);
    } else {
      items.add(CartItemModel(product: event.product, quantity: event.quantity));
    }

    await _saveCart(items);
    emit(state.copyWith(items: items));
  }

  Future<void> _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    final items = state.items.where((item) => item.product.id != event.productId).toList();
    await _saveCart(items);
    emit(state.copyWith(items: items));
  }

  Future<void> _onQuantityUpdated(CartQuantityUpdated event, Emitter<CartState> emit) async {
    if (event.quantity <= 0) {
      add(CartItemRemoved(event.productId));
      return;
    }

    final items = List<CartItemModel>.from(state.items);
    final index = items.indexWhere((item) => item.product.id == event.productId);

    if (index >= 0) {
      items[index] = CartItemModel(product: items[index].product, quantity: event.quantity);
      await _saveCart(items);
      emit(state.copyWith(items: items));
    }
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    await _saveCart(const []);
    emit(state.copyWith(items: const []));
  }

  Future<void> _saveCart(List<CartItemModel> items) async {
    try {
      final cartModel = CartStateModel(items: items);
      final jsonString = jsonEncode(cartModel.toJson());
      await _prefs.setString(_storageKey, jsonString);
    } catch (_) {
      // Ignore error
    }
  }
}
