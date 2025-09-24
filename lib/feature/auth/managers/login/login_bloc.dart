import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/lokal_data_storege/token_storage.dart';
import '../../../../data/model/auth/login_model.dart';
import '../../../../data/repostories/auth_repostoriya.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository = LoginRepository();

  LoginBloc() : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginClearError>(_onLoginClearError);
    on<LoginClearState>(_onLoginClearState);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    try {
      final result = await _repository.login(
        LoginModel(
          login: event.login, 
          password: event.password
        )
      );

      await result.fold(
        (error) async {
          emit(state.copyWith(
            isLoading: false, 
            errorMessage: _formatError(error),
            isSuccess: false,
          ));
        },
        (token) async {
          if (token.isNotEmpty) {
            try {
              await TokenStorage.saveToken(token);
              emit(state.copyWith(
                isLoading: false, 
                errorMessage: null,
                isSuccess: true,
              ));
            } catch (e) {
              emit(state.copyWith(
                isLoading: false, 
                errorMessage: "Failed to save token: ${e.toString()}",
                isSuccess: false,
              ));
            }
          } else {
            emit(state.copyWith(
              isLoading: false, 
              errorMessage: "Empty token received",
              isSuccess: false,
            ));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
        isLoading: false, 
        errorMessage: "Unexpected error: ${e.toString()}",
        isSuccess: false,
      ));
    }
  }

  void _onLoginClearError(
    LoginClearError event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  void _onLoginClearState(
    LoginClearState event,
    Emitter<LoginState> emit,
  ) {
    emit(const LoginState());
  }

  String _formatError(Exception exception) {
    String errorMessage = exception.toString();

    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }

    final lower = errorMessage.toLowerCase();
    if (lower.contains('invalid credentials') || 
        lower.contains('wrong password') || 
        lower.contains('incorrect password')) {
      return 'Invalid email or password';
    } else if (lower.contains('user not found') || 
               lower.contains('email not found')) {
      return 'Account not found. Please check your email';
    } else if (lower.contains('account disabled') || 
               lower.contains('account suspended')) {
      return 'Account is disabled. Please contact support';
    } else if (lower.contains('network')) {
      return 'Network error. Please check your connection';
    } else if (lower.contains('timeout')) {
      return 'Request timeout. Please try again';
    } else if (lower.contains('server')) {
      return 'Server error. Please try again later';
    }

    return errorMessage;
  }
}

