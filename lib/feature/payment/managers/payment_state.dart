// lib/features/cards/bloc/card_state.dart


import 'package:store_app/data/model/payment_card/payment_card_model.dart';

abstract class PaymentState {}

class CardInitialState extends PaymentState {}

class CardLoadingState extends PaymentState {}

class CardsLoadedState extends PaymentState {
  final List<PaymentCardModel> cards;

  CardsLoadedState(this.cards);
}

class CardCreatedState extends PaymentState {
  final String message;

  CardCreatedState(this.message);
}

class CardDeletedState extends PaymentState {
  final String message;

  CardDeletedState(this.message);
}

class CardErrorState extends PaymentState {
  final String error;

  CardErrorState(this.error);
}