import 'package:flutter/material.dart';
import 'package:store_app/core/result.dart';
import '../../../data/repostories/auth_repostoriya.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  bool _isLoading = false;
  String? _errorMessage;

  String? _email;
  String? _code;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get email => _email;
  String? get code => _code;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setCode(String code) {
    _code = code;
    notifyListeners();
  }

  Future<bool> sendResetCode([String? email]) async {
    final usedEmail = email ?? _email;
    if (usedEmail == null || !_isValidEmail(usedEmail)) {
      _setError('Please enter a valid email address');
      return false;
    }

    final success = await _handleRequest(() => _repository.sendResetCode(usedEmail));
    if (success) {
      _email = usedEmail;
      notifyListeners();
    }
    return success;
  }

  Future<bool> verifyCode([String? code]) async {
    final usedCode = code ?? _code;
    if (usedCode == null || usedCode.length != 4) {
      _setError('Please enter a 4-digit code');
      return false;
    }
    if (_email == null) {
      _setError('Email not set. Please restart the process.');
      return false;
    }

    final success = await _handleRequest(() => _repository.verifyCode(_email!, usedCode));
    if (success) {
      _code = usedCode;
      notifyListeners();
    }
    return success;
  }

  Future<bool> resetPassword(String newPassword) async {
    if (newPassword.length < 8) {
      _setError('Password must be at least 8 characters long');
      return false;
    }
    if (_email == null || _code == null) {
      _setError('Missing email or code. Please restart the process.');
      return false;
    }

    final success = await _handleRequest(
      () => _repository.resetPassword(_email!, _code!, newPassword),
    );

    if (success) {
      clearAll();
    }
    return success;
  }

  Future<bool> _handleRequest(Future<Result<String>> Function() request) async {
    _setLoading(true);
    try {
      final result = await request();
      return _handleResult(result);
    } catch (e) {
      _setError('Network error. Please try again.');
      return false;
    }
  }

  bool _handleResult(Result<String> result) {
    _setLoading(false);
    bool success = false;

    result.fold(
      (error) {
        _errorMessage = _mapError(error);
        success = false;
      },
      (data) {
        _errorMessage = null;
        success = true;
      },
    );

    notifyListeners();
    return success;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String _mapError(dynamic error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('404')) return 'Email not found';
    if (msg.contains('400')) return 'Invalid request';
    if (msg.contains('500')) return 'Server error. Please try again later';
    if (msg.contains('timeout')) return 'Connection timeout. Please try again';
    return 'Something went wrong. Please try again';
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearAll() {
    _email = null;
    _code = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
