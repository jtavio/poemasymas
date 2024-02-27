import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBloc = context.read<BottomNavigationBloc>();
    return BlocBuilder<BottomNavigationBloc, int>(
      builder: (context, currentTabIndex) {
        return BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (index) => bottomNavigationBloc.add(TapChangeEvent(index)),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_outlined),
              label: 'Notificaciones',
            )
          ],
        );
      },
    );
  }
}
