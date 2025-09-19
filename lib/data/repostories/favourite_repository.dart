import '../../core/client.dart';
import '../model/home_model.dart/product_model.dart';

class ProductRepositories {
  final ApiClient _client;

  ProductRepositories(this._client);

  Future<List<ProductModel>> getSavedProduct() async {
    final result = await _client.get<List<dynamic>>('/products/saved-products');
    if (result.isSuccess) {
      final List<dynamic> data = result.data ?? [];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw result.exception ?? Exception("Saqlanganlarni olishda xatolik");
    }
  }
}
