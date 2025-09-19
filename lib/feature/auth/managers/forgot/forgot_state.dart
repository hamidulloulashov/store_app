import 'package:equatable/equatable.dart';

class ForgotPasswordState extends Equatable {
  final bool isLoading;
  final String? email;
  final String? code;
  final String? errorMessage;

  const ForgotPasswordState({
    this.isLoading = false,
    this.email,
    this.code,
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    bool? isLoading,
    String? email,
    String? code,
    String? errorMessage,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      code: code ?? this.code,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, email, code, errorMessage];
}
