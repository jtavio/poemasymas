part of 'authors_bloc.dart';

abstract class AuthorsEvent extends Equatable {
  const AuthorsEvent();

  @override
  List<Object> get props => [];
}

class LoadApiEvent extends AuthorsEvent {
  final Authors authors;

  const LoadApiEvent(this.authors);
}

class RemoveDataAuthorsEvent extends AuthorsEvent {}

class NewAuthorsQueryEvent extends AuthorsEvent {
  final List<QueryAuthors> queryAuthors;

  const NewAuthorsQueryEvent(this.queryAuthors);
}

class HomeAuthorsErrorEvent extends AuthorsEvent {}
