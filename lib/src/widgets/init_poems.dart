import 'dart:async';

import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/pages/author-title/author_title_poems.dart';
import 'package:app_poemas/src/pages/signin/sign-in.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitPoems extends StatelessWidget {
  final StreamController<String> streamController;
  final TextEditingController editingController;
  final AuthorTitleBloc titleAuthor;
  final FirebaseAnalytics analytics;
  const InitPoems({
    Key? key,
    required this.streamController,
    required this.editingController,
    required this.titleAuthor,
    required this.analytics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Poems',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFFF9E80),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const SignIn()),
              (route) => false,
            );
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 8.0, bottom: 15.0),
              child: TextField(
                onChanged: (value) {
                  streamController.add(value);
                },
                controller: editingController,
                decoration: const InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  labelStyle:
                      TextStyle(color: Color.fromARGB(255, 82, 209, 171)),
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 82, 209, 171)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 82, 209, 171)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AuthorsBloc, AuthorsState>(
                builder: (context, state) {
                  if (state.authors != null) {
                    final auth = state.authors!.authors.length.toInt();
                    return ListView.separated(
                      itemCount: auth,
                      separatorBuilder: (context, i) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            state.authors!.authors[index],
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () async {
                            _registerEventAnalyticsAuthorTitle(
                                state.authors!.authors[index]);
                            await titleAuthor.getItemTitleAuthor(
                                state.authors!.authors[index]);
                            titleAuthor.add(
                                SaveNameAuthor(state.authors!.authors[index]));
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AuthorTitle(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  if (state.queryAuthors != null) {
                    final authQuery = state.queryAuthors!.length;
                    return ListView.separated(
                      itemCount: authQuery,
                      separatorBuilder: (context, i) => const Divider(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            state.queryAuthors![index].author,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () async {
                            await titleAuthor.getItemTitleAuthor(
                                state.queryAuthors![index].author);
                            titleAuthor.add(SaveNameAuthor(
                                state.queryAuthors![index].author));
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AuthorTitle(),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  if (state.error != null) {
                    return Center(
                      child: Text(state.error!['message']),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _registerEventAnalyticsAuthorTitle(String index) async {
    await analytics.logEvent(
      name: 'authorTitle',
      parameters: <String, dynamic>{
        'id': '$index',
      },
    );
    // mostrarMensaje('logEvent succeeded');
  }
}
