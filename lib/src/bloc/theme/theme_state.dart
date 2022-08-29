part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeChangeState extends ThemeState {
  final ThemeData themeData;

  const ThemeChangeState(this.themeData);
}
