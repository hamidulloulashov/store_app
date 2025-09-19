import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/notifaction_repositoriya.dart' show NotificationRepository;
import 'package:store_app/feature/notifacton/managers/notifaction_state.dart' show NotificationState, NotificationInitial, NotificationLoaded, NotificationLoading, NotificationError;


class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit(this.repository) : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());

    final result = await repository.fetchNotifications();

    result.fold(
      (error) => emit(NotificationError(error.toString())),
      (data) {
        if (data.isEmpty) {
          emit(const NotificationLoaded([])); 
        } else {
          emit(NotificationLoaded(data)); 
        }
      },
    );
  }
}
