import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading;
  final String? email;
  final String? code;
  final String? errorMessage;
  final bool isCodeSent;
  final bool isCodeVerified;
  final bool isPasswordReset;

  const ForgotPasswordState({
    this.isLoading = false,
    this.email,
    this.code,
    this.errorMessage,
    this.isCodeSent = false,
    this.isCodeVerified = false,
    this.isPasswordReset = false,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? email,
    String? code,
    String? errorMessage,
    bool? isCodeSent,
    bool? isCodeVerified,
    bool? isPasswordReset,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      code: code ?? this.code,
      errorMessage: errorMessage,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isCodeVerified: isCodeVerified ?? this.isCodeVerified,
      isPasswordReset: isPasswordReset ?? this.isPasswordReset,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        email,
        code,
        errorMessage,
        isCodeSent,
        isCodeVerified,
        isPasswordReset,
      ];
}
