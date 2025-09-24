import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddCartItem extends CartEvent {
  final int productId;
  final int quantity;
  final int sizeId;
  const AddCartItem({required this.productId, required this.quantity, required this.sizeId});
  @override
  List<Object?> get props => [productId, quantity, sizeId];
}

class RemoveCartItem extends CartEvent {
  final int cartItemId;
  const RemoveCartItem(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}

class IncreaseQuantity extends CartEvent {
  final int cartItemId;
  const IncreaseQuantity(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}

class DecreaseQuantity extends CartEvent {
  final int cartItemId;
  const DecreaseQuantity(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}