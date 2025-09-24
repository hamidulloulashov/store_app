import 'package:store_app/core/client.dart' show ApiClient;

class SearchRepository {
  final ApiClient _client = ApiClient();

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    final result = await _client.get<List<dynamic>>(
      "/products/filter",
      queryParams: {"Title": query},
    );
    return List<Map<String, dynamic>>.from(result.data ?? []);
  }
}
