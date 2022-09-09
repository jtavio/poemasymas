part of 'author_title_bloc.dart';

abstract class AuthorTitleEvent extends Equatable {
  const AuthorTitleEvent();

  @override
  List<Object> get props => [];
}

class LoadApiTitleForAuthorEvent extends AuthorTitleEvent {
  final Author author;

  const LoadApiTitleForAuthorEvent(this.author);
}

class SaveNameAuthor extends AuthorTitleEvent {
  final String counterLike;

  const SaveNameAuthor(this.counterLike);
}

class DeleteCounterLikeState extends AuthorTitleEvent {
  final String counter;

  const DeleteCounterLikeState(this.counter);
}

class DeleteTitlePoemState extends AuthorTitleEvent {
  final Author deleteAuthor;

  const DeleteTitlePoemState(this.deleteAuthor);
}
