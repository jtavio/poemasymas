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
  final String nameAuthor;

  const SaveNameAuthor(this.nameAuthor);
}

class SaveTitlePoemByAuthor extends AuthorTitleEvent {
  final List<TitleByAuthor> titlePoem;

  const SaveTitlePoemByAuthor(this.titlePoem);
}

class DeleteStatePoemByAuthor extends AuthorTitleEvent {
  final List<TitleByAuthor> titlePoem;

  const DeleteStatePoemByAuthor(this.titlePoem);
}

class DeleteTitlePoemState extends AuthorTitleEvent {
  final Author deleteAuthor;

  const DeleteTitlePoemState(this.deleteAuthor);
}
