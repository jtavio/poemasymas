import 'package:app_poemas/src/pages/profile/profile_user.dart';
import 'package:app_poemas/src/pages/notifications/notifications_screen.dart';
import 'package:app_poemas/src/views/poems_view.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatelessWidget {
  final int index;
  const TabsScreen({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [const PoemsView(), const ProfileUser(), const NotificationsScreen()];
    return myList[index];
  }
}
