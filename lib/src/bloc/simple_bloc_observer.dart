import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('blocevent: $event');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    print('blocerror: $error');
    super.onError(bloc, error, stacktrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('bloc: $bloc: change: $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('bloc: $bloc: transition: $transition');
  }
}
