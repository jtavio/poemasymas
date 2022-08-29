import 'package:app_poemas/src/pages/author-title/title_poem_test.dart';
import 'package:app_poemas/src/pages/home_authors.dart';
import 'package:flutter/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  TitlePoemByAuthor.routeName: (context) => const TitlePoemByAuthor(),
  HomeAuthors.routeName: (context) => const HomeAuthors()
};
