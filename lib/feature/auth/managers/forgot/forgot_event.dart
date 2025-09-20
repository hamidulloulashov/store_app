import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendResetCodeRequested extends ForgotPasswordEvent {
  final String email;

  const SendResetCodeRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyCodeRequested extends ForgotPasswordEvent {
  final String code;

  const VerifyCodeRequested({required this.code});

  @override
  List<Object?> get props => [code];
}

class ResetPasswordRequested extends ForgotPasswordEvent {
  final String newPassword;

  const ResetPasswordRequested({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class EmailSet extends ForgotPasswordEvent {
  final String email;

  const EmailSet({required this.email});

  @override
  List<Object?> get props => [email];
}

class CodeSet extends ForgotPasswordEvent {
  final String code;

  const CodeSet({required this.code});

  @override
  List<Object?> get props => [code];
}

class ErrorCleared extends ForgotPasswordEvent {
  const ErrorCleared();
}

class StateCleared extends ForgotPasswordEvent {
  const StateCleared();
}