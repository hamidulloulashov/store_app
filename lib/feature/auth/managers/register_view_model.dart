import 'package:flutter/material.dart';
import 'package:store_app/core/lokal_data_storege/token_storage.dart';
import 'package:store_app/data/model/auth/register_model.dart';
import 'package:store_app/data/repostories/auth_repostoriya.dart';

class RegisterViewModel extends ChangeNotifier {
  final RegisterRepostory _repository = RegisterRepostory();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register(String fullName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _repository.register(
      RegisterModel(fullName: fullName, email: email, password: password,),
    );

    bool success = false;

    result.fold(
      (error) {
        _errorMessage = error.toString();
        success = false;
      },
      (response) async {
        if (response.contains("eyJ")) {
          await TokenStorage.saveToken(response);
        }
        success = true;
      },
    );

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
