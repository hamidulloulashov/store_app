import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/card_repository.dart' show CartRepository;
import 'package:store_app/feature/card/managers/card_event.dart' show CartEvent, LoadCart, AddCartItem, RemoveCartItem, IncreaseQuantity, DecreaseQuantity;
import 'package:store_app/feature/card/managers/card_state.dart' show CartState, CartInitial, CartLoaded, CartLoading, CartError, CartEmpty;


class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartInitial()) {
    on<LoadCart>(_onLoad);
    on<AddCartItem>(_onAdd);
    on<RemoveCartItem>(_onRemove);
    on<IncreaseQuantity>(_onIncrease);
    on<DecreaseQuantity>(_onDecrease);
  }

  Future<void> _onLoad(LoadCart e, Emitter<CartState> emit) async {
    emit(CartLoading());
    final res = await repository.fetchCart();
    res.fold(
      (err) => emit(CartError(err.toString())),
      (cart) => cart.items.isEmpty ? emit(CartEmpty()) : emit(CartLoaded(cart)),
    );
  }

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

  Future<void> _onRemove(RemoveCartItem e, Emitter<CartState> emit) async {
    emit(CartLoading());
    final res = await repository.removeItem(e.cartItemId);
    res.fold(
      (err) => emit(CartError(err.toString())),
      (_) => add(LoadCart()),
    );
  }

  Future<void> _onIncrease(IncreaseQuantity e, Emitter<CartState> emit) async {
  if (state is! CartLoaded) return;
  final cart = (state as CartLoaded).cart;
  final item = cart.items.firstWhere((i) => i.id == e.cartItemId);
  final newQty = item.quantity + 1;

  emit(CartLoading());
  final res = await repository.addItem(
    productId: item.productId,
    quantity: newQty,
    sizeId: item.sizeId,
  );
  res.fold(
    (err) => emit(CartError(err.toString())),
    (_) => add(LoadCart()),
  );
}

Future<void> _onDecrease(DecreaseQuantity e, Emitter<CartState> emit) async {
  if (state is! CartLoaded) return;
  final cart = (state as CartLoaded).cart;
  final item = cart.items.firstWhere((i) => i.id == e.cartItemId);
  final newQty = item.quantity - 1;
  if (newQty < 1) return;

  emit(CartLoading());
  final res = await repository.addItem(
    productId: item.productId,
    quantity: newQty,
    sizeId: item.sizeId,
  );
  res.fold(
    (err) => emit(CartError(err.toString())),
    (_) => add(LoadCart()),
  );
}

}