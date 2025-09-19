import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/lokal_data_storege/token_storage.dart';
import 'package:store_app/data/model/auth/register_model.dart';
import 'package:store_app/data/repostories/auth_repostoriya.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepository _repository = RegisterRepository();

  RegisterCubit() : super(const RegisterState());

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final result = await _repository.register(
        RegisterModel(
          fullName: fullName,
          email: email,
          password: password,
        ),
      );

      return await result.fold(
        (error) {
          emit(state.copyWith(
              isLoading: false, errorMessage: _formatError(error)));
          return false;
        },
        (token) async {
          if (token.isNotEmpty) {
            try {
              await TokenStorage.saveToken(token);
              emit(state.copyWith(isLoading: false, errorMessage: null));
              return true;
            } catch (e) {
              emit(state.copyWith(
                  isLoading: false,
                  errorMessage: "Failed to save token: ${e.toString()}"));
              return false;
            }
          } else {
            emit(state.copyWith(
                isLoading: false, errorMessage: "Empty token received"));
            return false;
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Unexpected error: ${e.toString()}"));
      return false;
    }
  }

  String _formatError(Exception exception) {
    String errorMessage = exception.toString();

    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }

    if (errorMessage.toLowerCase().contains('email already exists')) {
      return 'This email is already registered';
    } else if (errorMessage.toLowerCase().contains('network')) {
      return 'Network error. Please check your connection';
    } else if (errorMessage.toLowerCase().contains('timeout')) {
      return 'Request timeout. Please try again';
    } else if (errorMessage.toLowerCase().contains('server')) {
      return 'Server error. Please try again later';
    }

    return errorMessage;
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearState() {
    emit(const RegisterState());
  }
}
