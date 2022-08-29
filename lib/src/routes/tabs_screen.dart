import 'package:app_poemas/src/pages/profile/profile_user.dart';
import 'package:app_poemas/src/pages/promotions/promotions.dart';
import 'package:app_poemas/src/views/poems_view.dart';
import 'package:flutter/material.dart';

class Routes extends StatelessWidget {
  final int index;
  const Routes({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [PoemsView(), ProfileUser(), Promotions()];
    return myList[index];
  }
}
