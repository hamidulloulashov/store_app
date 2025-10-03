// order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/order_repository.dart';
import 'package:store_app/feature/order/managers/order_event.dart';
import 'package:store_app/feature/order/managers/order_state.dart';


class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc(this.repository) : super(const OrderInitial()) {
    on<LoadOrdersEvent>(_onLoadOrders);
    on<ChangeOrderTabEvent>(_onChangeTab);
    on<DeleteOrderEvent>(_onDeleteOrder);
    on<CreateOrderEvent>(_onCreateOrder);
    on<LoadOrderTrackingEvent>(_onLoadTracking);
  }

  Future<void> _onLoadOrders(
    LoadOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await repository.getOrders();

    result.fold(
      (error) => emit(OrderError(error.toString())),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }

  void _onChangeTab(
    ChangeOrderTabEvent event,
    Emitter<OrderState> emit,
  ) {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      emit(currentState.copyWith(currentTabIndex: event.tabIndex));
    }
  }

  Future<void> _onDeleteOrder(
    DeleteOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      
      emit(OrderDeleting(event.orderId));

      final result = await repository.deleteOrder(event.orderId);

      result.fold(
        (error) {
          emit(OrderError(error.toString()));
          emit(currentState);
        },
        (_) {
          final updatedOrders = currentState.orders
              .where((order) => order.id != event.orderId)
              .toList();
          emit(currentState.copyWith(orders: updatedOrders));
        },
      );
    }
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderCreating());

    final result = await repository.createOrder(
      addressId: event.addressId,
      paymentMethod: event.paymentMethod,
      cardId: event.cardId,
      promoCode: event.promoCode,
    );

    result.fold(
      (error) => emit(OrderError(error.toString())),
      (order) => emit(OrderCreated(order)),
    );
  }

  Future<void> _onLoadTracking(
    LoadOrderTrackingEvent event,
    Emitter<OrderState> emit,
  ) async {
    if (state is OrdersLoaded) {
      final currentState = state as OrdersLoaded;
      final order = currentState.orders.firstWhere(
        (o) => o.id == event.orderId,
      );

      emit(const OrderLoading());

      final result = await repository.getOrderTracking(event.orderId);

      result.fold(
        (error) {
          emit(OrderError(error.toString()));
          emit(currentState);
        },
        (tracking) => emit(OrderTrackingLoaded(
          tracking: tracking,
          order: order,
        )),
      );
    }
  }
}