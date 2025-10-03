// order_state.dart
import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/order/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

// Boshlang'ich holat
class OrderInitial extends OrderState {
  const OrderInitial();
}

// Yuklanmoqda
class OrderLoading extends OrderState {
  const OrderLoading();
}

// Buyurtmalar yuklandi
class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  final int currentTabIndex; // 0 = Ongoing, 1 = Completed
  
  const OrdersLoaded({
    required this.orders,
    this.currentTabIndex = 0,
  });

  // Ongoing orderlarni filter qilish
  List<OrderModel> get ongoingOrders => orders
      .where((order) => order.status.toLowerCase() != 'completed')
      .toList();

  // Completed orderlarni filter qilish
  List<OrderModel> get completedOrders => orders
      .where((order) => order.status.toLowerCase() == 'completed')
      .toList();

  OrdersLoaded copyWith({
    List<OrderModel>? orders,
    int? currentTabIndex,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }

  @override
  List<Object?> get props => [orders, currentTabIndex];
}

// Buyurtma o'chirilmoqda
class OrderDeleting extends OrderState {
  final int orderId;
  
  const OrderDeleting(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

// Buyurtma yaratilmoqda
class OrderCreating extends OrderState {
  const OrderCreating();
}

// Buyurtma yaratildi
class OrderCreated extends OrderState {
  final OrderModel order;
  
  const OrderCreated(this.order);

  @override
  List<Object?> get props => [order];
}

// Tracking ma'lumotlari yuklandi
class OrderTrackingLoaded extends OrderState {
  final List<OrderTrackingStatus> tracking;
  final OrderModel order;
  
  const OrderTrackingLoaded({
    required this.tracking,
    required this.order,
  });

  @override
  List<Object?> get props => [tracking, order];
}

// Xatolik
class OrderError extends OrderState {
  final String message;
  
  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}