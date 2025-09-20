import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String login;
  final String password;

  const LoginSubmitted({
    required this.login,
    required this.password,
  });

  @override
  List<Object?> get props => [login, password];
}

class LoginClearError extends LoginEvent {
  const LoginClearError();
}

class LoginClearState extends LoginEvent {
  const LoginClearState();
}

