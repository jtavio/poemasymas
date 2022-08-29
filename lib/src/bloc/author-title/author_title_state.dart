part of 'author_title_bloc.dart';

class AuthorTitleState extends Equatable {
  final List<AuthorItem> poemsTitle;
  final String nameAuthor;
  final List<TitleByAuthor> titlePoem;
  final Map<String, dynamic>? error;

  const AuthorTitleState({
    this.poemsTitle = const [],
    this.nameAuthor = "",
    this.titlePoem = const [],
    this.error,
  });

  AuthorTitleState copyWith({
    List<AuthorItem>? poemsTitle,
    String? nameAuthor,
    List<TitleByAuthor>? titlePoem,
    Map<String, dynamic>? error,
  }) =>
      AuthorTitleState(
        poemsTitle: poemsTitle ?? this.poemsTitle,
        nameAuthor: nameAuthor ?? this.nameAuthor,
        titlePoem: titlePoem ?? this.titlePoem,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [poemsTitle, nameAuthor, titlePoem, error];

  @override
  String tostring() =>
      '{poemsTitle: $poemsTitle, nameAuthor: $nameAuthor, titlePoem: $titlePoem, error: $error}';
}

class AuthorTitleInitial extends AuthorTitleState {}
