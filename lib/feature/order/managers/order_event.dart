// order_event.dart
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

// Buyurtmalarni yuklash
class LoadOrdersEvent extends OrderEvent {
  const LoadOrdersEvent();
}

// Tab o'zgartirish (Ongoing/Completed)
class ChangeOrderTabEvent extends OrderEvent {
  final int tabIndex; // 0 = Ongoing, 1 = Completed
  
  const ChangeOrderTabEvent(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

// Buyurtmani o'chirish
class DeleteOrderEvent extends OrderEvent {
  final int orderId;
  
  const DeleteOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

// Buyurtma yaratish (Checkout dan)
class CreateOrderEvent extends OrderEvent {
  final int addressId;
  final String paymentMethod;
  final int? cardId;
  final String? promoCode;
  
  const CreateOrderEvent({
    required this.addressId,
    required this.paymentMethod,
    this.cardId,
    this.promoCode,
  });

  @override
  List<Object?> get props => [addressId, paymentMethod, cardId, promoCode];
}

// Order tracking ma'lumotlarini yuklash
class LoadOrderTrackingEvent extends OrderEvent {
  final int orderId;
  
  const LoadOrderTrackingEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}