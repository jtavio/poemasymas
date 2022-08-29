import 'package:app_poemas/src/models/author_item_model.dart';
import 'package:app_poemas/src/models/author_title.dart';
import 'package:app_poemas/src/services/https_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'author_title_event.dart';
part 'author_title_state.dart';

class AuthorTitleBloc extends Bloc<AuthorTitleEvent, AuthorTitleState> {
  HttpServices httpServices;
  AuthorTitleBloc({required this.httpServices}) : super(AuthorTitleInitial()) {
    on<LoadApiTitleForAuthorEvent>(
        (event, emit) => emit(state.copyWith(poemsTitle: event.poemsTitle)));
    on<SaveNameAuthor>(
        (event, emit) => emit(state.copyWith(nameAuthor: event.nameAuthor)));
    on<SaveTitlePoemByAuthor>(
        (event, emit) => emit(state.copyWith(titlePoem: event.titlePoem)));
    on<DeleteStatePoemByAuthor>(
        (event, emit) => emit(state.copyWith(titlePoem: event.titlePoem)));
    on<DeleteTitlePoemState>(
        (event, emit) => emit(state.copyWith(poemsTitle: event.poemsTitle)));
  }

  Future getItemTitleAuthor(String title) async {
    final authorAll = await httpServices.getItemsAuthor(title);
    add(LoadApiTitleForAuthorEvent(authorAll));
  }

  Future getTitlePoem(String name, String title) async {
    final titlePoem = await httpServices.getTitlePoem(name, title);
    add(SaveTitlePoemByAuthor(titlePoem));
  }
}
