// import 'package:app_poemas/src/models/author_query.dart';
// import 'package:app_poemas/src/models/authors_model.dart';
// import 'package:app_poemas/src/services/https_services.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';

// part 'authors_event.dart';
// part 'authors_state.dart';

// class AuthorsBloc extends Bloc<AuthorsEvent, AuthorsState> {
//   HttpServices httpServices;
//   AuthorsBloc({required this.httpServices}) : super(HomeAuthorsLoadingState()) {
//     on<LoadApiEvent>(
//         (event, emit) => emit(state.copyWith(authors: event.authors)));
//     on<RemoveDataAuthorsEvent>(
//         (event, emit) => emit(HomeAuthorsLoadingState()));
//     on<NewAuthorsQueryEvent>((event, emit) =>
//         emit(state.copyWith(queryAuthors: event.queryAuthors)));
//     on<HomeAuthorsErrorEvent>((event, emit) => emit(state.copyWith(error: {
//           'code': 1,
//           'message': 'En este momento no podemos procesar tu solicitud'
//         })));
//   }

//   // Future getAllAuthors() async {
//   //   final authorAll = await httpServices.getAllAuthors();
//   //   if (authorAll != null) {
//   //     add(LoadApiEvent(authorAll));
//   //   }
//   //   add(HomeAuthorsErrorEvent());
//   // }

//   // Future queryAuthors(query) async {
//   //   final authorAll = await httpServices.queryAuthors(query);
//   //   if (authorAll != null) {
//   //     add(NewAuthorsQueryEvent(authorAll));
//   //   }
//   //   add(HomeAuthorsErrorEvent());
//   // }

//   // emit(HomeAuthorsLoadingState());
//   // emit(HomeAuthorsLoadedState(authorAll));
// }
