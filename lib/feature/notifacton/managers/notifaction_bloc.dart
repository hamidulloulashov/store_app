import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifaction_event.dart';
import 'notifaction_state.dart';
import 'package:store_app/data/repostories/notifaction_repositoriya.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());

      final result = await repository.fetchNotifications();

      result.fold(
        (error) => emit(NotificationError(error.toString())),
        (data) => emit(NotificationLoaded(data)),
      );
    });
  }
}
