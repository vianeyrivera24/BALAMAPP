part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  const NotificationStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;

  const NotificationReceived(this.pushMessage);

  @override
  List<Object?> get props => [pushMessage];
}

class LoadNotifications extends NotificationsEvent {
  final List<PushMessage> notifications;

  const LoadNotifications(this.notifications);

  @override
  List<Object?> get props => [notifications];
}
