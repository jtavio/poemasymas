import 'dart:io';

import 'package:app_poemas/src/domain/entities/push_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

part 'notification_push_event.dart';
part 'notification_push_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationPushBloc extends Bloc<NotificationPushEvent, NotificationPushState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationPushBloc() : super(NotificationPushInitial()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    on<NotificationReceived>(_onPushMessageReceived);

    onRequestPermission();
    _initialStatusCheck();
    _onForegroundMessage();
  }

  void _notificationStatusChanged(NotificationStatusChanged event, Emitter<NotificationPushState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageReceived(NotificationReceived event, Emitter<NotificationPushState> emit) {
    emit(state.copyWith(notifications: [event.pushMessage, ...state.notifications]));
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print(token);
  }

  void handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilist');
    print('Message data: ${message.data}');
    if (message.notification == null) return;

    print('message also: ${message.notification}');

    final notification = PushMessage(
      messageId: message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification?.title ?? '',
      body: message.notification?.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageurl: Platform.isAndroid ? message.notification?.android?.imageUrl : message.notification?.apple?.imageUrl,
    );
    add(NotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void onRequestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String id) {
    final exist = state.notifications.any((element) => element.messageId == id);
    if (!exist) return null;
    return state.notifications.firstWhere((element) => element.messageId == id);
  }
}
