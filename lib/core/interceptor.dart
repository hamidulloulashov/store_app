import 'package:dio/dio.dart';
import 'package:store_app/core/lokal_data_storege/token_storage.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    print("➡️ REQUEST[${options.method}] => PATH: ${options.path}");
    print("Headers: ${options.headers}");
    print("Data: ${options.data}");

    return handler.next(options); 
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    return handler.next(response); 
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}");
    return handler.next(err);
  }
}
