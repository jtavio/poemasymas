import 'dart:async';

import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/pages/author-title/title_poem_test.dart';
import 'package:app_poemas/src/pages/signin/sign-in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitPoems extends StatefulWidget {
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
  State<InitPoems> createState() => _InitPoemsState();
}

class _InitPoemsState extends State<InitPoems> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('authors').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Poemas',
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
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 8.0, right: 8.0, top: 8.0, bottom: 15.0),
            //   child: TextField(
            //     onChanged: (value) {
            //       widget.streamController.add(value);
            //     },
            //     controller: widget.editingController,
            //     decoration: const InputDecoration(
            //       labelText: "Search",
            //       hintText: "Search",
            //       labelStyle:
            //           TextStyle(color: Color.fromARGB(255, 82, 209, 171)),
            //       prefixIcon: Icon(Icons.search,
            //           color: Color.fromARGB(255, 82, 209, 171)),
            //       focusedBorder: UnderlineInputBorder(
            //         borderSide:
            //             BorderSide(color: Color.fromARGB(255, 82, 209, 171)),
            //       ),
            //     ),
            //   ),
            // ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                          'En este momento no podemos procesar tu solicitud'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final res = snapshot.data!.docs;
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No hay Peomas para mostrar'));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: List.generate(
                        res.length,
                        (index) {
                          return Card(
                            color: const Color.fromARGB(178, 155, 155, 155),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(res[index]['title'],
                                      style: const TextStyle(fontSize: 20)),
                                  Text('${res[index]['lineas'][0]}...',
                                      maxLines: 3,
                                      style: const TextStyle(fontSize: 16)),
                                  MaterialButton(
                                    color:
                                        const Color.fromARGB(255, 82, 209, 171),
                                    onPressed: () async {
                                      _registerEventAnalyticsAuthorTitle(
                                          res[index]['title']);

                                      print('${res[index].id}');
                                      await widget.titleAuthor
                                          .getItemTitleAuthor(res[index].id);

                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TitlePoemByAuthor(
                                            id: res[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Leer...',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _registerEventAnalyticsAuthorTitle(String index) async {
    await widget.analytics.logEvent(
      name: 'authorTitle',
      parameters: <String, dynamic>{
        'id': '$index',
      },
    );
    // mostrarMensaje('logEvent succeeded');
  }
}
