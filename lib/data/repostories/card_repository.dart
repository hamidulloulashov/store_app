import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/card/card_model.dart';

class CartRepository {
  final ApiClient apiClient;
  CartRepository({required this.apiClient});

  Future<Result<CartModel>> fetchCart() async {
    final res = await apiClient.get<Map<String, dynamic>>('/my-cart/my-cart-items');
    return res.fold(
      (e) => Result.error(e),
      (data) => Result.ok(CartModel.fromJson(data)),
    );
  }

  Future<Result<void>> addItem({
    required int productId,
    required int quantity,
    required int sizeId,
  }) async {
    final res = await apiClient.post<Map<String, dynamic>>(
      '/my-cart/add-item',
      data: {'productId': productId, 'quantity': quantity, 'sizeId': sizeId},
    );
    return res.fold(
      (e) => Result.error(e),
      (_) => const Result.ok(null),
    );
  }

  Future<Result<void>> removeItem(int cartItemId) async {
    final res = await apiClient.delete<Map<String, dynamic>>('/my-cart/delete/$cartItemId');
    return res.fold(
      (e) => Result.error(e),
      (_) => const Result.ok(null),
    );
  }
}
