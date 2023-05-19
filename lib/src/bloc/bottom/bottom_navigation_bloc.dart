import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, int> {
  BottomNavigationBloc() : super(0) {
    on<TapChangeEvent>((event, emit) {
      emit(event.newIndex);
    });
  }
}
