part of 'author_title_bloc.dart';

class AuthorTitleState extends Equatable {
  final Author? author;
  final String counterLike;
  final List<TitleByAuthor> titlePoem;
  final Map<String, dynamic>? error;

  const AuthorTitleState({
    this.author,
    this.counterLike = "",
    this.titlePoem = const [],
    this.error,
  });

  AuthorTitleState copyWith({
    Author? author,
    String? counterLike,
    List<TitleByAuthor>? titlePoem,
    Map<String, dynamic>? error,
  }) =>
      AuthorTitleState(
        author: author ?? this.author,
        counterLike: counterLike ?? this.counterLike,
        titlePoem: titlePoem ?? this.titlePoem,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [author, counterLike, titlePoem, error];

  @override
  String tostring() =>
      '{poemsTitle: $author, nameAuthor: $counterLike, titlePoem: $titlePoem, error: $error}';
}

class AuthorTitleInitial extends AuthorTitleState {}
