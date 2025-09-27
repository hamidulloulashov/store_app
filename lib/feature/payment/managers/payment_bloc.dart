import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/payment_repository.dart';
import 'package:store_app/feature/payment/managers/payment_event.dart';
import 'package:store_app/feature/payment/managers/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;

  PaymentBloc(this._repository) : super(CardInitialState()) {
    on<LoadCardsEvent>(_onLoadCards);
    on<CreateCardEvent>(_onCreateCard);
    on<DeleteCardEvent>(_onDeleteCard);
    on<ResetCardStateEvent>(_onResetState);
  }

  Future<void> _onLoadCards(
      LoadCardsEvent event, Emitter<PaymentState> emit) async {
    emit(CardLoadingState());
    final result = await _repository.getCards();

    result.fold(
      (error) => emit(CardErrorState(error.toString())),
      (cards) => emit(CardsLoadedState(cards)),
    );
  }

  Future<void> _onCreateCard(
  CreateCardEvent event,
  Emitter<PaymentState> emit,
) async {
  emit(CardLoadingState());

  final result = await _repository.createCard(event.request);

  result.fold(
    (error) => emit(CardErrorState(error.toString())),
    (_) {
      emit(CardCreatedState("✅ Karta muvaffaqiyatli yaratildi"));
      add(LoadCardsEvent()); 
    },
  );
}


  Future<void> _onDeleteCard(
      DeleteCardEvent event, Emitter<PaymentState> emit) async {
    emit(CardLoadingState());
    final result = await _repository.deleteCard(event.cardId);

    result.fold(
      (error) => emit(CardErrorState(error.toString())),
      (_) {
        emit(CardDeletedState("Karta muvaffaqiyatli o'chirildi!"));
        add(LoadCardsEvent());
      },
    );
  }

  void _onResetState(
      ResetCardStateEvent event, Emitter<PaymentState> emit) {
    emit(CardInitialState());
  }
}
