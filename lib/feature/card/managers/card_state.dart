import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/card/card_model.dart' show CartModel;

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartEmpty extends CartState {}
class CartLoaded extends CartState {
  final CartModel cart;
  const CartLoaded(this.cart);
  @override
  List<Object?> get props => [cart];
}
class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}