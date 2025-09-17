import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/auth/login_model.dart';
import 'package:store_app/data/model/auth/register_model.dart';

/// Ro‘yxatdan o‘tish uchun repository
class RegisterRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Result<String>> register(RegisterModel registerModel) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      "/auth/register",
      data: registerModel.toJson(),
    );

    return result.fold(
      (error) => Result.error(error),
      (data) {
        final token = data["token"] as String?;
        if (token != null) {
          return Result.ok(token);
        }
        final message =
            data["message"] as String? ?? "Ro‘yxatdan o‘tish muvaffaqiyatli";
        return Result.ok(message);
      },
    );
  }
}

/// Login qilish uchun repository
class LoginRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Result<String>> login(LoginModel loginModel) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      "/auth/login",
      data: loginModel.toJson(),
    );

    return result.fold(
      (error) => Result.error(error),
      (data) {
        final token = data["accessToken"] as String?;
        if (token != null) {
          return Result.ok(token);
        }
        final message = data["message"] as String? ?? "Login muvaffaqiyatli";
        return Result.ok(message);
      },
    );
  }
}

class ForgotPasswordRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Result<String>> sendResetCode(String email) async {
    final res = await _apiClient.post<dynamic>(
      "/auth/reset-password/email",
      data: {"email": email},
    );

    return res.fold(
      (err) => Result.error(err),
      (data) {
        if (data is Map<String, dynamic>) {
          final msg = data["message"]?.toString() ?? "";
          if (_hasError(msg)) return Result.error(Exception(msg));
          return Result.ok(msg.isNotEmpty ? msg : "Code sent");
        } else if (data is String) {
          if (_hasError(data)) return Result.error(Exception(data));
          return Result.ok(data);
        }
        return Result.error(Exception("Noma'lum javob formati"));
      },
    );
  }

  Future<Result<String>> verifyCode(String email, String code) async {
    final res = await _apiClient.post<dynamic>(
      "/auth/reset-password/verify",
      data: {"email": email, "code": code},
    );

    return res.fold(
      (err) => Result.error(err),
      (data) {
        if (data is Map<String, dynamic>) {
          return Result.ok(data["message"]?.toString() ?? "Code verified");
        } else if (data is String) {
          return Result.ok(data);
        } else if (data is bool) {
          return data ? Result.ok("Code verified") : Result.error(Exception("Code not valid"));
        }
        return Result.error(Exception("Noma'lum javob formati: $data"));
      },
    );
  }

  /// Parolni tiklash
  Future<Result<String>> resetPassword(
    String email,
    String code,
    String password,
  ) async {
    final res = await _apiClient.post<dynamic>(
      "/auth/reset-password/reset",
      data: {"email": email, "code": code, "password": password},
    );

    return res.fold(
      (err) => Result.error(err),
      (data) {
        if (data is Map<String, dynamic>) {
          final msg = data["message"]?.toString() ?? "";
          if (_hasError(msg)) return Result.error(Exception(msg));
          return Result.ok(msg.isNotEmpty ? msg : "Password reset successful");
        } else if (data is String) {
          if (_hasError(data)) return Result.error(Exception(data));
          return Result.ok(data);
        }
        return Result.error(Exception("Noma'lum javob formati: $data"));
      },
    );
  }

  /// Xatolik borligini tekshiradigan helper
  bool _hasError(String msg) {
    final lower = msg.toLowerCase();
    return lower.contains("wrong") || lower.contains("error");
  }
}
