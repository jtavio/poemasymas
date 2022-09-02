// import 'package:app_poemas/src/bloc/blocs.dart';
// // import 'package:app_poemas/src/pages/author-title/title_poem.dart';
// import 'package:app_poemas/src/pages/author-title/title_poem_test.dart';
// import 'package:app_poemas/src/pages/home_authors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthorTitle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final nameTitle = BlocProvider.of<AuthorTitleBloc>(context);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           nameTitle.state.nameAuthor,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         backgroundColor: Colors.deepOrangeAccent[100],
//         elevation: 0,
//         leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               BlocProvider.of<AuthorTitleBloc>(context, listen: false)
//                   .add(const DeleteTitlePoemState([]));
//               BlocProvider.of<AuthorsBloc>(context, listen: false)
//                   .add(RemoveDataAuthorsEvent());
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => const HomeAuthors(),
//                 ),
//               );
//             }),
//       ),
//       body: BlocBuilder<AuthorTitleBloc, AuthorTitleState>(
//         builder: (context, state) {
//           if (state.poemsTitle.isNotEmpty) {
//             final titleAuthor = state.poemsTitle;
//             return ListView.separated(
//               itemCount: titleAuthor.length,
//               separatorBuilder: (context, i) => const Divider(),
//               itemBuilder: (context, index) {
//                 // print('state: ${state.poemsTitle[index].title}');
//                 // print('state: ${state.poemsTitle[index].linecount}');
//                 return ListTile(
//                   leading:
//                       const Icon(Icons.menu_book_outlined, color: Colors.black),
//                   title: Text(
//                     state.poemsTitle[index].title,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontFamily: 'Montserrat',
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   subtitle:
//                       Text('Lineas: ${state.poemsTitle[index].linecount}'),
//                   onTap: () async {
//                     // await nameTitle.getTitlePoem(nameTitle.state.nameAuthor,
//                     //     state.poemsTitle[index].title);

//                     // ignore: use_build_context_synchronously
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) => TitlePoemByAuthor(
//                             title: state.poemsTitle[index].title),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//           if (state.error != null) {
//             return Center(
//               child: Text(state.error!['message']),
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }
// }
