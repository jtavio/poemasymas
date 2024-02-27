import 'package:app_poemas/src/bloc/notification-push/notification_push_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  static var routeName = 'notification';
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationPushBloc>().state.notifications;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notificaciones',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFFF9E80),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: (notifications.isNotEmpty)
              ? ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification.title),
                      subtitle: Text(notification.body),
                      //leading: notification.imageurl != null ? Image.network(notification.imageurl!) : null,
                    );
                  })
              : const Text('No hay notificaciones disponibles'),
        ),
      ),
    );
  }
}
