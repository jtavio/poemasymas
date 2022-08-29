part of 'bottom_navigation_bloc.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class TapChangeEvent extends BottomNavigationEvent {
  final int newIndex;

  const TapChangeEvent(this.newIndex);

  @override
  List<Object> get props => [newIndex];

  @override
  String toString() {
    return 'EVENTO: tabEvent: $newIndex';
  }
}
