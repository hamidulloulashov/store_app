import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/feature/auth/managers/forgot/forgot_state.dart';

import '../../../../data/repostories/auth_repostoriya.dart';
import 'forgot_event.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<SendResetCodeRequested>(_onSendResetCodeRequested);
    on<VerifyCodeRequested>(_onVerifyCodeRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<EmailSet>(_onEmailSet);
    on<CodeSet>(_onCodeSet);
    on<ErrorCleared>(_onErrorCleared);
    on<StateCleared>(_onStateCleared);
  }

  void setEmail(String email) {
    add(EmailSet(email: email));
  }

  void setCode(String code) {
    add(CodeSet(code: code));
  }

  void clearError() {
    add(const ErrorCleared());
  }

  void clearAll() {
    add(const StateCleared());
  }

  Future<bool> sendResetCode([String? email]) async {
    final usedEmail = email ?? state.email;
    if (usedEmail == null || !_isValidEmail(usedEmail)) {
      emit(state.copyWith(
        errorMessage: 'Please enter a valid email address',
        isLoading: false,
      ));
      return false;
    }

    add(SendResetCodeRequested(email: usedEmail));
    
    await stream.firstWhere((state) => !state.isLoading);
    return state.isCodeSent;
  }

  Future<bool> verifyCode([String? code]) async {
    final usedCode = code ?? state.code;
    if (usedCode == null || usedCode.length != 4) {
      emit(state.copyWith(
        errorMessage: 'Please enter a 4-digit code',
        isLoading: false,
      ));
      return false;
    }
    if (state.email == null) {
      emit(state.copyWith(
        errorMessage: 'Email not set. Please restart the process.',
        isLoading: false,
      ));
      return false;
    }

    add(VerifyCodeRequested(code: usedCode));
    
    await stream.firstWhere((state) => !state.isLoading);
    return state.isCodeVerified;
  }

  Future<bool> resetPassword(String newPassword) async {
    if (newPassword.length < 8) {
      emit(state.copyWith(
        errorMessage: 'Password must be at least 8 characters long',
        isLoading: false,
      ));
      return false;
    }
    if (state.email == null || state.code == null) {
      emit(state.copyWith(
        errorMessage: 'Missing email or code. Please restart the process.',
        isLoading: false,
      ));
      return false;
    }

    add(ResetPasswordRequested(newPassword: newPassword));
    
    await stream.firstWhere((state) => !state.isLoading);
    return state.isPasswordReset;
  }

  Future<void> _onSendResetCodeRequested(
    SendResetCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isCodeSent: false));

    try {
      final result = await _repository.sendResetCode(event.email);
      
      result.fold(
        (error) => emit(state.copyWith(
          isLoading: false,
          errorMessage: _mapError(error),
          isCodeSent: false,
        )),
        (data) => emit(state.copyWith(
          isLoading: false,
          email: event.email,
          errorMessage: null,
          isCodeSent: true,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Network error. Please try again.',
        isCodeSent: false,
      ));
    }
  }

  Future<void> _onVerifyCodeRequested(
    VerifyCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isCodeVerified: false));

    try {
      final result = await _repository.verifyCode(state.email!, event.code);
      
      result.fold(
        (error) => emit(state.copyWith(
          isLoading: false,
          errorMessage: _mapError(error),
          isCodeVerified: false,
        )),
        (data) => emit(state.copyWith(
          isLoading: false,
          code: event.code,
          errorMessage: null,
          isCodeVerified: true,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Network error. Please try again.',
        isCodeVerified: false,
      ));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isPasswordReset: false));

    try {
      final result = await _repository.resetPassword(
        state.email!,
        state.code!,
        event.newPassword,
      );
      
      result.fold(
        (error) => emit(state.copyWith(
          isLoading: false,
          errorMessage: _mapError(error),
          isPasswordReset: false,
        )),
        (data) => emit(state.copyWith(
          isLoading: false,
          errorMessage: null,
          isPasswordReset: true,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Network error. Please try again.',
        isPasswordReset: false,
      ));
    }
  }

  void _onEmailSet(
    EmailSet event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(email: event.email, errorMessage: null));
  }

  void _onCodeSet(
    CodeSet event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(code: event.code, errorMessage: null));
  }

  void _onErrorCleared(
    ErrorCleared event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  void _onStateCleared(
    StateCleared event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(const ForgotPasswordState());
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