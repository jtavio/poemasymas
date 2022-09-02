part of 'author_title_bloc.dart';

class AuthorTitleState extends Equatable {
  final Author? author;
  final String nameAuthor;
  final List<TitleByAuthor> titlePoem;
  final Map<String, dynamic>? error;

  const AuthorTitleState({
    this.author,
    this.nameAuthor = "",
    this.titlePoem = const [],
    this.error,
  });

  AuthorTitleState copyWith({
    Author? author,
    String? nameAuthor,
    List<TitleByAuthor>? titlePoem,
    Map<String, dynamic>? error,
  }) =>
      AuthorTitleState(
        author: author ?? this.author,
        nameAuthor: nameAuthor ?? this.nameAuthor,
        titlePoem: titlePoem ?? this.titlePoem,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [author, nameAuthor, titlePoem, error];

  @override
  String tostring() =>
      '{poemsTitle: $author, nameAuthor: $nameAuthor, titlePoem: $titlePoem, error: $error}';
}

class AuthorTitleInitial extends AuthorTitleState {}
