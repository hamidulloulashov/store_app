import 'package:bloc/bloc.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/feature/auth/managers/forgot/forgot_state.dart' show ForgotPasswordState;

import '../../../../data/repostories/auth_repostoriya.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void setEmail(String email) {
    emit(state.copyWith(email: email, errorMessage: null));
  }

  void setCode(String code) {
    emit(state.copyWith(code: code, errorMessage: null));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearAll() {
    emit(const ForgotPasswordState());
  }

  Future<bool> sendResetCode([String? email]) async {
    final usedEmail = email ?? state.email;
    if (usedEmail == null || !_isValidEmail(usedEmail)) {
      _setError('Please enter a valid email address');
      return false;
    }

    final success = await _handleRequest(() => _repository.sendResetCode(usedEmail));
    if (success) {
      emit(state.copyWith(email: usedEmail));
    }
    return success;
  }

  Future<bool> verifyCode([String? code]) async {
    final usedCode = code ?? state.code;
    if (usedCode == null || usedCode.length != 4) {
      _setError('Please enter a 4-digit code');
      return false;
    }
    if (state.email == null) {
      _setError('Email not set. Please restart the process.');
      return false;
    }

    final success = await _handleRequest(() => _repository.verifyCode(state.email!, usedCode));
    if (success) {
      emit(state.copyWith(code: usedCode));
    }
    return success;
  }

  Future<bool> resetPassword(String newPassword) async {
    if (newPassword.length < 8) {
      _setError('Password must be at least 8 characters long');
      return false;
    }
    if (state.email == null || state.code == null) {
      _setError('Missing email or code. Please restart the process.');
      return false;
    }

    final success = await _handleRequest(
      () => _repository.resetPassword(state.email!, state.code!, newPassword),
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
        _setError(_mapError(error));
        success = false;
      },
      (data) {
        _setError(null);
        success = true;
      },
    );

    return success;
  }

  void _setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  void _setError(String? message) {
    emit(state.copyWith(errorMessage: message, isLoading: false));
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
}
