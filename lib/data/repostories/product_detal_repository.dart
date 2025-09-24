import 'package:store_app/core/client.dart' show ApiClient;

import '../model/home/product_detail_model.dart';
class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ProductDetailModel> fetchProductDetail(int id) async {
    final response = await _apiClient.get('/products/detail/$id');

  
    final result = await _apiClient.get('/products/detail/$id');

return result.fold(
  (error) => throw Exception(error.toString()),      
  (data) => ProductDetailModel.fromJson(data),       
);

  }
}
