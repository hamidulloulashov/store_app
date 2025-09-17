import 'package:dio/dio.dart';
import 'package:store_app/core/interceptor.dart';
import 'package:store_app/core/result.dart';

class ApiClient {
  final Dio _dio;
  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: "http://192.168.10.137:8888/api/v1",
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(AppInterceptor());

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParams);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Result.ok(response.data as T);
      } else {
        return Result.error(Exception("Server error: ${response.statusCode}"));
      }
    } on DioException catch (dioError) {
      return Result.error(Exception(_handleDioError(dioError)));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response =
          await _dio.post(path, data: data, queryParameters: queryParams);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return Result.ok(response.data as T);
      } else {
        return Result.error(Exception("Server error: ${response.statusCode}"));
      }
    } on DioException catch (dioError) {
      return Result.error(Exception(_handleDioError(dioError)));
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }

  String _handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return 'Server bilan bog\'lanish vaqti tugadi';
      case DioExceptionType.receiveTimeout:
        return 'Server javob berishda sekin';
      case DioExceptionType.connectionError:
        return 'Internet aloqasini tekshiring';
      case DioExceptionType.badResponse:
        return 'Server xatosi: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}';
      default:
        return 'Tarmoq xatosi: ${dioError.error ?? "noma’lum xato"}';
    }
  }
}
