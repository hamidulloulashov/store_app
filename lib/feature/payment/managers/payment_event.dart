import 'package:store_app/data/model/payment_card/payment_card_request.dart';

abstract class PaymentEvent {}

class LoadCardsEvent extends PaymentEvent {}

class CreateCardEvent extends PaymentEvent {
  final CreateCardRequest request;

  CreateCardEvent(this.request);
}

class DeleteCardEvent extends PaymentEvent {
  final int cardId;

  DeleteCardEvent(this.cardId);
}

class ResetCardStateEvent extends PaymentEvent {}
