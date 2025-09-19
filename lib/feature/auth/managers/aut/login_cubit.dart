import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/lokal_data_storege/token_storage.dart';
import '../../../../data/model/auth/login_model.dart';
import '../../../../data/repostories/auth_repostoriya.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository _repository = LoginRepository();

  LoginCubit() : super(const LoginState());

  Future<bool> login(String login, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _repository.login(LoginModel(login: login, password: password));

      return await result.fold(
        (error) async {
          emit(state.copyWith(isLoading: false, errorMessage: _formatError(error)));
          return false;
        },
        (token) async {
          if (token.isNotEmpty) {
            try {
              await TokenStorage.saveToken(token);
              emit(state.copyWith(isLoading: false, errorMessage: null));
              return true;
            } catch (e) {
              emit(state.copyWith(isLoading: false, errorMessage: "Failed to save token: ${e.toString()}"));
              return false;
            }
          } else {
            emit(state.copyWith(isLoading: false, errorMessage: "Empty token received"));
            return false;
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: "Unexpected error: ${e.toString()}"));
      return false;
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearState() {
    emit(const LoginState());
  }

  String _formatError(Exception exception) {
    String errorMessage = exception.toString();

    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }

    final lower = errorMessage.toLowerCase();
    if (lower.contains('invalid credentials') || lower.contains('wrong password') || lower.contains('incorrect password')) {
      return 'Invalid email or password';
    } else if (lower.contains('user not found') || lower.contains('email not found')) {
      return 'Account not found. Please check your email';
    } else if (lower.contains('account disabled') || lower.contains('account suspended')) {
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
