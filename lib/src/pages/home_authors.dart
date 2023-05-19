import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/routes/tabs_screen.dart';
import 'package:app_poemas/src/widgets/custom_bottom_navigation.dart';

class HomeAuthors extends StatefulWidget {
  static const routeName = 'home';
  const HomeAuthors({Key? key}) : super(key: key);

  @override
  State<HomeAuthors> createState() => _HomeAuthorsState();
}

class _HomeAuthorsState extends State<HomeAuthors> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, int>(
      builder: (context, currentTabIndex) {
        return Scaffold(
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to exit app'),
            ),
            child: TabsScreen(index: currentTabIndex),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }
}
