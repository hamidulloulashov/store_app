import 'package:store_app/core/client.dart' show ApiClient;
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/update_profile.dart/profile_update_model.dart';

class ProfileUpdateRepository {
  final ApiClient _apiClient;

  ProfileUpdateRepository(this._apiClient);

  Future<Result<ProfileUpdateModel>> updateProfile(ProfileUpdateModel profile) async {
    try {
      final result = await _apiClient.patch<Map<String, dynamic>>(
        '/auth/update',
        data: profile.toJson(),
      );

      return result.fold(
        (error) => Result.error(error),
        (data) => Result.ok(ProfileUpdateModel.fromJson(data)),
      );
    } catch (e) {
      return Result.error(Exception('Failed to update profile: $e'));
    }
  }

  Future<Result<ProfileUpdateModel>> getCurrentProfile() async {
    try {
      final result = await _apiClient.get<Map<String, dynamic>>('/auth/me');
      
      return result.fold(
        (error) => Result.error(error),
        (data) => Result.ok(ProfileUpdateModel.fromJson(data)),
      );
    } catch (e) {
      return Result.error(Exception('Failed to get profile: $e'));
    }
  }
}