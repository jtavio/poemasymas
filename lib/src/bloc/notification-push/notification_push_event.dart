part of 'notification_push_bloc.dart';

abstract class NotificationPushEvent {
  const NotificationPushEvent();
}

class NotificationStatusChanged extends NotificationPushEvent {
  final AuthorizationStatus status;

  NotificationStatusChanged(this.status);
}

class NotificationReceived extends NotificationPushEvent {
  final PushMessage pushMessage;

  NotificationReceived(this.pushMessage);
}
