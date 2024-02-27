import 'dart:async';

import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/widgets/init_poems.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

class PoemsView extends StatefulWidget {
  const PoemsView({
    Key? key,
  }) : super(key: key);

  @override
  State<PoemsView> createState() => _PoemsViewState();
}

class _PoemsViewState extends State<PoemsView> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController editingController = TextEditingController();
  StreamController<String> streamController = StreamController();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  void initState() {
    streamController.stream.debounce(const Duration(seconds: 2)).listen((event) => _validateValues());
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Home-View', screenClassOverride: 'Home-View');
  }

  _validateValues() {
    if (editingController.text.length > 3) {
      // code here
      Future.delayed(const Duration(seconds: 2));
      debugPrint('esto es: ${editingController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleAuthor = BlocProvider.of<AuthorTitleBloc>(context);
    if (user != null) {
      return InitPoems(
        streamController: streamController,
        editingController: editingController,
        titleAuthor: titleAuthor,
        analytics: analytics,
      );
    } else {
      return InitPoems(
        streamController: streamController,
        editingController: editingController,
        titleAuthor: titleAuthor,
        analytics: analytics,
      );
    }
  }
}
