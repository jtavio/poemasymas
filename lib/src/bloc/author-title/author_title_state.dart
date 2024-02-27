part of 'author_title_bloc.dart';

class AuthorTitleState extends Equatable {
  final Author? author;
  final String counterLike;
  final Map<String, dynamic>? error;

  const AuthorTitleState({
    this.author,
    this.counterLike = "",
    this.error,
  });

  AuthorTitleState copyWith({
    Author? author,
    String? counterLike,
    Map<String, dynamic>? error,
  }) =>
      AuthorTitleState(
        author: author ?? this.author,
        counterLike: counterLike ?? this.counterLike,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [author, counterLike, error];

  String tostring() =>
      '{poemsTitle: $author, nameAuthor: $counterLike, error: $error}';
}

class AuthorTitleInitial extends AuthorTitleState {}
