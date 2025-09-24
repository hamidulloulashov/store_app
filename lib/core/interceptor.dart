import 'package:dio/dio.dart';
import 'package:store_app/core/lokal_data_storege/token_storage.dart';


class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await TokenStorage.getToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      print("➡️ REQUEST[${options.method}] => PATH: ${options.path}");
      if (options.headers.isNotEmpty) print("Headers: ${options.headers}");
      if (options.data != null) print("Data: ${options.data}");
    } catch (e) {
      print("⚠️ Tokenni olishda yoki so‘rovni tayyorlashda xatolik: $e");
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    final path = err.requestOptions.path;
    print("❌ ERROR[${code ?? 'NO CODE'}] => PATH: $path");
    print("Message: ${err.message}");
    return handler.next(err);
  }
}
