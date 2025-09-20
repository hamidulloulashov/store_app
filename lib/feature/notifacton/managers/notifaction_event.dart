import 'package:equatable/equatable.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

final class LoadNotifications extends NotificationEvent {}
