part of 'authors_bloc.dart';

class AuthorsState extends Equatable {
  final Authors? authors;
  final List<QueryAuthors>? queryAuthors;
  final Map<String, dynamic>? error;

  const AuthorsState({this.authors, this.queryAuthors, this.error});

  AuthorsState copyWith({
    Authors? authors,
    List<QueryAuthors>? queryAuthors,
    Map<String, dynamic>? error,
  }) =>
      AuthorsState(
        authors: authors ?? this.authors,
        queryAuthors: queryAuthors ?? this.queryAuthors,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [authors, queryAuthors, error];
  @override
  String tostring() =>
      '{authors: $authors,queryAuthors: $queryAuthors,error: $error}';
}

class HomeAuthorsLoadingState extends AuthorsState {
  @override
  List<Object> get props => [];
}
