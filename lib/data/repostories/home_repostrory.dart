import 'package:store_app/core/client.dart';
import 'package:store_app/data/model/home/product_model.dart';
import 'package:store_app/data/model/home/product_detail_model.dart';
import 'package:store_app/data/model/sort/sort_model.dart';

abstract class ProductRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<ProductModel>> getProducts({int? categoryId});
  Future<ProductDetailModel> getProductDetail(int productId);
  Future<void> toggleLikeProduct(String productId, {required bool isLiked});

  Future<List<SortModel>> getSortedProducts({
    int? categoryId,
    int? sizeId,
    String? title,
    double? minPrice,
    double? maxPrice,
    String? orderBy,
  });
}

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient _client;
  ProductRepositoryImpl(this._client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final result = await _client.get<List<dynamic>>('/categories/list');
    if (result.isSuccess) {
      return (result.data ?? []).map((e) => CategoryModel.fromJson(e)).toList();
    }
    throw result.exception ?? Exception("Kategoriya olishda xatolik");
  }

  @override
  Future<List<ProductModel>> getProducts({int? categoryId}) async {
    final result = await _client.get<List<dynamic>>("/products/list");
    if (result.isSuccess) {
      final products = (result.data ?? []).map((e) => ProductModel.fromJson(e)).toList();
      if (categoryId != null && categoryId != 0) {
        return products.where((p) => p.categoryId == categoryId).toList();
      }
      return products;
    }
    throw result.exception ?? Exception("Product olishda xatolik");
  }

  @override
  Future<ProductDetailModel> getProductDetail(int productId) async {
    final result = await _client.get<Map<String, dynamic>>('/products/detail/$productId');
    if (result.isSuccess) return ProductDetailModel.fromJson(result.data!);
    throw result.exception ?? Exception("Product detail olishda xatolik");
  }

  @override
  Future<void> toggleLikeProduct(String productId, {required bool isLiked}) async {
    final endpoint = isLiked ? '/auth/unsave/$productId' : '/auth/save/$productId';
    final result = await _client.post(endpoint, data: null);
    if (!result.isSuccess) {
      throw result.exception ?? Exception(isLiked ? "Unsave xatolik" : "Save xatolik");
    }
  }

  @override
  Future<List<SortModel>> getSortedProducts({
    int? categoryId,
    int? sizeId,
    String? title,
    double? minPrice,
    double? maxPrice,
    String? orderBy,
  }) async {
    final queryParams = <String, dynamic>{};
    if (categoryId != null) queryParams['categoryId'] = categoryId;
    if (sizeId != null) queryParams['sizeId'] = sizeId;
    if (title != null && title.isNotEmpty) queryParams['title'] = title;
    if (minPrice != null) queryParams['minPrice'] = minPrice;
    if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
    if (orderBy != null) queryParams['orderBy'] = orderBy;

    final result = await _client.get<List<dynamic>>('/products/list', queryParams: queryParams);
    if (result.isSuccess) {
      return (result.data ?? []).map((e) => SortModel.fromJson(e)).toList();
    }
    throw result.exception ?? Exception('Sort product olishda xatolik');
  }
}
