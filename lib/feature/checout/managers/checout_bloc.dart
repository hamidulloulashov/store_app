import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/checout_repository.dart' show CheckoutRepository;
import 'package:store_app/feature/checout/managers/checout_event.dart' show CheckoutEvent, LoadCheckoutData, SelectPaymentMethod, SelectAddress, SelectCard, ApplyPromoCode, PlaceOrder;
import 'package:store_app/feature/checout/managers/checout_state.dart' show CheckoutState, CheckoutInitial, CheckoutLoading, CheckoutLoaded, CheckoutError, CheckoutOrderPlaced;

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository repository;

  CheckoutBloc(this.repository) : super(CheckoutInitial()) {
    on<LoadCheckoutData>(_onLoadCheckoutData);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<SelectAddress>(_onSelectAddress);
    on<SelectCard>(_onSelectCard);
    on<ApplyPromoCode>(_onApplyPromoCode);
    on<PlaceOrder>(_onPlaceOrder);
  }

  Future<void> _onLoadCheckoutData(LoadCheckoutData event, Emitter<CheckoutState> emit) async {
    emit(CheckoutLoading());
    
    try {
      final addressResult = await repository.getUserAddresses();
      final paymentResult = await repository.getPaymentMethods();
      final cardsResult = await repository.getUserCards();
      
      addressResult.fold(
        (error) => emit(CheckoutError(error.toString())),
        (addresses) {
          paymentResult.fold(
            (error) => emit(CheckoutError(error.toString())),
            (paymentMethods) {
              cardsResult.fold(
                (error) => emit(CheckoutError(error.toString())),
                (cards) {
                  emit(CheckoutLoaded(
                    addresses: addresses,
                    cards: cards,
                    paymentMethods: paymentMethods,
                    selectedAddress: addresses.isNotEmpty ? addresses.first : null,
                    selectedCard: cards.isNotEmpty ? cards.first : null,
                    selectedPaymentMethod: "Card",
                    promoCode: null,
                    discount: 0.0,
                  ));
                },
              );
            },
          );
        },
      );
    } catch (e) {
      emit(CheckoutError('Failed to load checkout data: $e'));
    }
  }

  void _onSelectPaymentMethod(SelectPaymentMethod event, Emitter<CheckoutState> emit) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(selectedPaymentMethod: event.paymentMethod));
    }
  }

  void _onSelectAddress(SelectAddress event, Emitter<CheckoutState> emit) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(selectedAddress: event.address));
    }
  }

  void _onSelectCard(SelectCard event, Emitter<CheckoutState> emit) {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      emit(currentState.copyWith(selectedCard: event.card));
    }
  }

  // Promo code faqat UI uchun - backend bilan bog'lanmaydi
  Future<void> _onApplyPromoCode(ApplyPromoCode event, Emitter<CheckoutState> emit) async {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      
      // Promo code backend tayyorlanmaguncha faqat UI da ko'rsatamiz
      // Hozircha hech qanday discount bermaymiz
      emit(currentState.copyWith(
        promoCode: event.promoCode,
        discount: 0.0,
        promoError: null,
      ));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<CheckoutState> emit) async {
    if (state is CheckoutLoaded) {
      final currentState = state as CheckoutLoaded;
      
      // Validation
      if (currentState.selectedAddress == null) {
        emit(const CheckoutError('Please select a delivery address'));
        emit(currentState.copyWith(isPlacingOrder: false));
        return;
      }
      
      if (currentState.selectedPaymentMethod == "Card" && currentState.selectedCard == null) {
        emit(const CheckoutError('Please select a card'));
        emit(currentState.copyWith(isPlacingOrder: false));
        return;
      }

      emit(currentState.copyWith(isPlacingOrder: true));

      final result = await repository.placeOrder(
        addressId: currentState.selectedAddress!.id,
        paymentMethod: currentState.selectedPaymentMethod,
        cardId: currentState.selectedCard?.id,
        promoCode: currentState.promoCode,
      );
      
      result.fold(
        (error) {
          emit(CheckoutError(error.toString()));
          emit(currentState.copyWith(isPlacingOrder: false));
        },
        (order) => emit(CheckoutOrderPlaced(order)),
      );
    }
  }
}