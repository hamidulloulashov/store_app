import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/checout/checout_model.dart' show AddressModel, OrderModel, CardModel;

abstract class CheckoutState extends Equatable {
  const CheckoutState();
  
  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final List<AddressModel> addresses;
  final List<CardModel> cards;
  final List<String> paymentMethods;
  final AddressModel? selectedAddress;
  final CardModel? selectedCard;
  final String selectedPaymentMethod;
  final String? promoCode;
  final double discount;
  final bool isApplyingPromo;
  final bool isPlacingOrder;
  final String? promoError;
  
  const CheckoutLoaded({
    required this.addresses,
    required this.cards,
    required this.paymentMethods,
    this.selectedAddress,
    this.selectedCard,
    required this.selectedPaymentMethod,
    this.promoCode,
    this.discount = 0.0,
    this.isApplyingPromo = false,
    this.isPlacingOrder = false,
    this.promoError,
  });
  
  CheckoutLoaded copyWith({
    List<AddressModel>? addresses,
    List<CardModel>? cards,
    List<String>? paymentMethods,
    AddressModel? selectedAddress,
    CardModel? selectedCard,
    String? selectedPaymentMethod,
    String? promoCode,
    double? discount,
    bool? isApplyingPromo,
    bool? isPlacingOrder,
    String? promoError,
  }) {
    return CheckoutLoaded(
      addresses: addresses ?? this.addresses,
      cards: cards ?? this.cards,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedCard: selectedCard ?? this.selectedCard,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      isApplyingPromo: isApplyingPromo ?? this.isApplyingPromo,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      promoError: promoError ?? this.promoError,
    );
  }
  
  @override
  List<Object?> get props => [
    addresses,
    cards,
    paymentMethods,
    selectedAddress,
    selectedCard,
    selectedPaymentMethod,
    promoCode,
    discount,
    isApplyingPromo,
    isPlacingOrder,
    promoError,
  ];
}

class CheckoutOrderPlaced extends CheckoutState {
  final OrderModel order;
  
  const CheckoutOrderPlaced(this.order);
  
  @override
  List<Object?> get props => [order];
}

class CheckoutError extends CheckoutState {
  final String message;
  
  const CheckoutError(this.message);
  
  @override
  List<Object?> get props => [message];
}