import 'package:store_app/data/model/home_model.dart/product_detail_model.dart'
    show CategoryModel, ProductModel;

import '../../core/client.dart';

abstract class ProductRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({int? categoryId});
  Future<ProductModel> getProductDetail(int productId);
  Future<void> toggleLikeProduct(String productId, {required bool isLiked});
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _client;

  ProductRepositoryImpl(this._client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await _client.get<List<dynamic>>('/categories/list');
    if (result.isSuccess) {
      final List<dynamic> data = result.data ?? [];
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      throw result.exception ?? Exception("Kategoriyalarni olishda xatolik");
    }
  }

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final result = await _client.get<List<dynamic>>("/products/list");
    if (result.isSuccess) {
      final List<dynamic> data = result.data ?? [];
      final products = data.map((e) => ProductModel.fromJson(e)).toList();

      if (categoryId != null && categoryId != 0) {
        return products.where((p) => p.categoryId == categoryId).toList();
      }
      return products;
    } else {
      throw result.exception ?? Exception("Productlarni olishda xatolik");
    }
  }

  @override
  Future<ProductModel> getProductDetail(int productId) async {
    final result =
        await _client.get<Map<String, dynamic>>('/products/detail/$productId');
    if (result.isSuccess) {
      return ProductModel.fromJson(result.data!);
    } else {
      throw result.exception ?? Exception("Product detailni olishda xatolik");
    }
  }

  @override
  Future<void> toggleLikeProduct(String productId, {required bool isLiked}) async {
    final endpoint = isLiked ? '/auth/unsave/$productId' : '/auth/save/$productId';
    final result = await _client.post(endpoint, data: null);

    if (!result.isSuccess) {
      throw result.exception ?? Exception(
          isLiked ? "Unsave qilishda xatolik" : "Save qilishda xatolik");
    }
  }
}
