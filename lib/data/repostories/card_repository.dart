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
    try {
      final res = await apiClient.post<Map<String, dynamic>>(
        '/my-cart/add-item',
        data: {
          'productId': productId,
          'quantity': quantity,
          'sizeId': sizeId,
        },
      );

      return res.fold(
        (e) => Result.error(e),
        (_) => const Result.ok(null),
      );
    } catch (e) {
      return Result.error(Exception('Failed to add item to cart: $e'));
    }
  }
 Future<Result<void>> removeItem(int cartItemId) async {
  try {
    final res = await apiClient.delete<dynamic>('/my-cart/delete/$cartItemId');
    return res.fold(
      (e) => Result.error(e),
      (_) => const Result.ok(null),
    );
  } catch (e) {
    return Result.error(Exception('Failed to remove item from cart: $e'));
  }
}

}
