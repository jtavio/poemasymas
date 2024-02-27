part of 'notification_push_bloc.dart';

class NotificationPushState extends Equatable {
  final AuthorizationStatus status;
  //opcional
  final List<PushMessage> notifications;
  const NotificationPushState({this.status = AuthorizationStatus.notDetermined, this.notifications = const []});

  NotificationPushState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
  }) =>
      NotificationPushState(status: status ?? this.status, notifications: notifications ?? this.notifications);

  @override
  List<Object> get props => [status, notifications];
}

class NotificationPushInitial extends NotificationPushState {}
