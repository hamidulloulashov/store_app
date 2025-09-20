
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/model/auth/register_model.dart' show RegisterModel;
import 'package:store_app/data/repostories/auth_repostoriya.dart' show RegisterRepository;
import 'package:store_app/feature/auth/managers/aut/register_event.dart' show RegisterEvent, RegisterSubmitted, RegisterClearError, RegisterClearState;
import 'package:store_app/feature/auth/managers/aut/register_state.dart' show RegisterState;

import '../../../../core/lokal_data_storege/token_storage.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _repository = RegisterRepository();

  RegisterBloc() : super(const RegisterState()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<RegisterClearError>(_onRegisterClearError);
    on<RegisterClearState>(_onRegisterClearState);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));

    try {
      final result = await _repository.register(
        RegisterModel(
          fullName: event.fullName,
          email: event.email,
          password: event.password,
        ),
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

  void _onRegisterClearError(
    RegisterClearError event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(errorMessage: null));
  }

  void _onRegisterClearState(
    RegisterClearState event,
    Emitter<RegisterState> emit,
  ) {
    emit(const RegisterState());
  }

  String _formatError(Exception exception) {
    String errorMessage = exception.toString();

    if (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.substring(11);
    }

    final lower = errorMessage.toLowerCase();
    if (lower.contains('email already exists') || lower.contains('user already exists')) {
      return 'This email is already registered';
    } else if (lower.contains('invalid email')) {
      return 'Please enter a valid email address';
    } else if (lower.contains('weak password') || lower.contains('password too short')) {
      return 'Password is too weak. Use at least 6 characters';
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