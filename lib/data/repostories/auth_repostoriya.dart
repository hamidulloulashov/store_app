import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/auth/register_model.dart';

class AuthRepository {
  final ApiClient _apiClient = ApiClient();

  Future<Result<String>> register(RegisterModel registerModel) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      "/auth/register",
      data: registerModel.toJson(),
    );

    return result.fold(
      (error) => Result.error(error),
      (data) {
        // Agar backend token qaytarsa
        final token = data["token"] as String?;
        if (token != null) {
          return Result.ok(token);
        }

        // Agar faqat "success message" qaytarsa
        final message = data["message"] as String? ?? "Ro‘yxatdan o‘tish muvaffaqiyatli";
        return Result.ok(message);
      },
    );
  }
}
