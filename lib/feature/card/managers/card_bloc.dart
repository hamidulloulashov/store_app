import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/card_repository.dart' show CartRepository;
import 'package:store_app/feature/card/managers/card_event.dart';
import 'package:store_app/feature/card/managers/card_state.dart';
import 'package:store_app/data/model/card/card_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartInitial()) {
    on<LoadCart>(_onLoad);
    on<AddCartItem>(_onAdd);
    on<RemoveCartItem>(_onRemove);
    on<IncreaseQuantity>(_onIncrease);
    on<DecreaseQuantity>(_onDecrease);
  }

  // Load cart
  Future<void> _onLoad(LoadCart e, Emitter<CartState> emit) async {
    emit(CartLoading());
    final res = await repository.fetchCart();
    res.fold(
      (err) => emit(CartError(err.toString())),
      (cart) => cart.items.isEmpty ? emit(CartEmpty()) : emit(CartLoaded(cart)),
    );
  }

  // Add new item (backend)
  Future<void> _onAdd(AddCartItem e, Emitter<CartState> emit) async {
    emit(CartLoading());
    final res = await repository.addItem(
      productId: e.productId,
      quantity: e.quantity,
      sizeId: e.sizeId,
    );
    res.fold(
      (err) => emit(CartError(err.toString())),
      (_) => add(LoadCart()),
    );
  }

  // Remove item (backend)
  Future<void> _onRemove(RemoveCartItem e, Emitter<CartState> emit) async {
    emit(CartLoading());
    final res = await repository.removeItem(e.cartItemId);
    res.fold(
      (err) => emit(CartError(err.toString())),
      (_) => add(LoadCart()),
    );
  }

  // Increase quantity (frontend update only)
  Future<void> _onIncrease(IncreaseQuantity e, Emitter<CartState> emit) async {
    if (state is! CartLoaded) return;

    final cart = (state as CartLoaded).cart;

    final updatedItems = cart.items.map((item) {
      if (item.id == e.cartItemId) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();

    final updatedCart = cart.copyWith(items: updatedItems);
    emit(CartLoaded(updatedCart));
  }

  // Decrease quantity (frontend update, remove if quantity reaches 1)
  Future<void> _onDecrease(DecreaseQuantity e, Emitter<CartState> emit) async {
    if (state is! CartLoaded) return;

    final cart = (state as CartLoaded).cart;
    final item = cart.items.firstWhere((i) => i.id == e.cartItemId);

    if (item.quantity <= 1) {
      // Quantity 1 ga yetganda backendga yuborish va itemni o'chirish
      add(RemoveCartItem(e.cartItemId));
      return;
    }

    final updatedItems = cart.items.map((i) {
      if (i.id == e.cartItemId) {
        return i.copyWith(quantity: i.quantity - 1);
      }
      return i;
    }).toList();

    final updatedCart = cart.copyWith(items: updatedItems);
    emit(CartLoaded(updatedCart));
  }
}
