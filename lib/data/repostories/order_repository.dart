// order_repository.dart
import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/order/order_model.dart';

class OrderRepository {
  final ApiClient apiClient;

  OrderRepository({required this.apiClient});

  // Buyurtmalar ro'yxatini olish
  Future<Result<List<OrderModel>>> getOrders() async {
    final result = await apiClient.get<Map<String, dynamic>>('/orders/list');
    
    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final ordersJson = data['orders'] as List<dynamic>;
          final orders = ordersJson
              .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.ok(orders);
        } catch (e) {
          return Result.error(Exception('Failed to parse orders: $e'));
        }
      },
    );
  }

  // Buyurtma yaratish
  Future<Result<OrderModel>> createOrder({
    required int addressId,
    required String paymentMethod,
    int? cardId,
    String? promoCode,
  }) async {
    final result = await apiClient.post<Map<String, dynamic>>(
      '/orders/create',
      data: {
        'address_id': addressId,
        'payment_method': paymentMethod,
        if (cardId != null) 'card_id': cardId,
        if (promoCode != null) 'promo_code': promoCode,
      },
    );

    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final order = OrderModel.fromJson(data);
          return Result.ok(order);
        } catch (e) {
          return Result.error(Exception('Failed to parse order: $e'));
        }
      },
    );
  }

  // Buyurtmani o'chirish
  Future<Result<void>> deleteOrder(int orderId) async {
    final result = await apiClient.delete<Map<String, dynamic>>(
      '/orders/delete',
      data: {'id': orderId},
    );

    return result.fold(
      (error) => Result.error(error),
      (_) => const Result.ok(null),
    );
  }

  // Buyurtma tracking ma'lumotlarini olish (ixtiyoriy)
  Future<Result<List<OrderTrackingStatus>>> getOrderTracking(int orderId) async {
    final result = await apiClient.get<Map<String, dynamic>>(
      '/orders/$orderId/tracking',
    );

    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final trackingJson = data['tracking'] as List<dynamic>;
          final tracking = trackingJson
              .map((json) => OrderTrackingStatus.fromJson(json as Map<String, dynamic>))
              .toList();
          return Result.ok(tracking);
        } catch (e) {
          return Result.error(Exception('Failed to parse tracking: $e'));
        }
      },
    );
  }
}