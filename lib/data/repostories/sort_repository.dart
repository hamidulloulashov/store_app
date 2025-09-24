import 'package:store_app/core/client.dart';
import 'package:store_app/data/model/sort/sort_model.dart';

abstract class SortRepository {
  Future<List<SortModel>> getProducts({
    int? categoryId,
    int? sizeId,
    String? title,
    double? minPrice,
    double? maxPrice,
    String? orderBy,
  });
}
class ProductRepositoryImpl implements SortRepository {
  final ApiClient _client;
  ProductRepositoryImpl(this._client);
  @override
  Future<List<SortModel>> getProducts({
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
      final data = result.data ?? [];
      return data.map((e) => SortModel.fromJson(e)).toList();
    } else {
      throw result.exception ?? Exception('Productlarni olishda xatolik');
    }
  }
}
