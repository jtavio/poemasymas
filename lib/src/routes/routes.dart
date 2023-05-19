import 'package:app_poemas/src/pages/add-poemas/add_poems.dart';
import 'package:app_poemas/src/pages/author-title/title_poem_test.dart';
import 'package:app_poemas/src/pages/home_authors.dart';
import 'package:app_poemas/src/pages/profile/profile_user.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  TitlePoemByAuthor.routeName: (context) => TitlePoemByAuthor(),
  HomeAuthors.routeName: (context) => const HomeAuthors(),
  AppPoemas.routeName: (context) => const AppPoemas(),
  ProfileUser.routeName: (context) => const ProfileUser(),
};
