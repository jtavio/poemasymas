import 'package:app_poemas/src/models/data_firestore.dart';
import 'package:app_poemas/src/services/https_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'author_title_event.dart';
part 'author_title_state.dart';

class AuthorTitleBloc extends Bloc<AuthorTitleEvent, AuthorTitleState> {
  HttpServices httpServices;
  AuthorTitleBloc({required this.httpServices}) : super(AuthorTitleInitial()) {
    on<LoadApiTitleForAuthorEvent>(
        (event, emit) => emit(state.copyWith(author: event.author)));
    on<SaveNameAuthor>(
        (event, emit) => emit(state.copyWith(counterLike: event.counterLike)));
    on<DeleteCounterLikeState>(
        (event, emit) => emit(state.copyWith(counterLike: event.counter)));
    on<DeleteTitlePoemState>(
        (event, emit) => emit(state.copyWith(author: event.deleteAuthor)));
  }

  Future getItemTitleAuthor(String id) async {
    final authorAll = await httpServices.getItemsAuthor(id);
    add(LoadApiTitleForAuthorEvent(authorAll));
  }

  Future addPoemsAuthor(Map<String, dynamic> value) async {
    bool res = await httpServices.addPoemsAuthor(value);
    return res;
  }

  Future addLike(String id, int value) async {
    await httpServices.addLike(id, value);
  }
}
