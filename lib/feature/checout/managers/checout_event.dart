import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/checout/checout_model.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckoutData extends CheckoutEvent {}

class SelectPaymentMethod extends CheckoutEvent {
  final String paymentMethod;
  const SelectPaymentMethod(this.paymentMethod);

  @override
  List<Object?> get props => [paymentMethod];
}

class SelectAddress extends CheckoutEvent {
  final AddressModel address;
  const SelectAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class SelectCard extends CheckoutEvent {
  final CardModel card;
  const SelectCard(this.card);

  @override
  List<Object?> get props => [card];
}

class ApplyPromoCode extends CheckoutEvent {
  final String promoCode;
  const ApplyPromoCode(this.promoCode);

  @override
  List<Object?> get props => [promoCode];
}

class PlaceOrder extends CheckoutEvent {}