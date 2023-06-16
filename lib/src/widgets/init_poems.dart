import 'dart:async';

import 'package:app_poemas/ad_state.dart';
import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/pages/add-poemas/add_poems.dart';
import 'package:app_poemas/src/pages/author-title/title_poem_test.dart';
import 'package:app_poemas/src/pages/signin/sign-in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
  static const AdRequest request = AdRequest();
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  User? user;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('authors').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'HomeInitPoems', screenClassOverride: 'HomeInitPoems');
    _loadBannerAd();
    user = FirebaseAuth.instance.currentUser;
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdState.bannerUnitId,
      request: const AdRequest(),
      size: AdSize.largeBanner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            print('onAdLoaded: true');
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('onAdLoaded: false');
          print('onAdLoaded: false $err');
          print('onAdLoaded: false $ad');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

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
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('En este momento no podemos procesar tu solicitud'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final res = snapshot.data!.docs;
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No hay Peomas para mostrar'));
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: GridView(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        children: List.generate(
                          res.length,
                          (index) {
                            return Card(
                              color: const Color.fromARGB(178, 155, 155, 155),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${res[index]['title']}...',
                                      style: const TextStyle(fontSize: 20),
                                      maxLines: 2,
                                    ),
                                    Text(
                                      '${res[index]['lineas'][0]}...',
                                      maxLines: 3,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    MaterialButton(
                                      color: const Color.fromARGB(255, 82, 209, 171),
                                      onPressed: () async {
                                        _registerEventAnalyticsAuthorTitle(res[index]['title']);

                                        print('${res[index].id}');
                                        await widget.titleAuthor.getItemTitleAuthor(res[index].id);

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => TitlePoemByAuthor(
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF64FFDA),
            onPressed: _actionButtonFloat,
            icon: const Icon(Icons.post_add_outlined),
            label: const Text(
              'Agregar',
            ),
          ),
        ),
        bottomNavigationBar: _isBannerAdReady
            ? SizedBox(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                //child: Text('hola mundo'),
                child: AdWidget(ad: _bannerAd),
              )
            : const SizedBox());
  }

  Future _registerEventAnalyticsAuthorTitle(String index) async {
    await widget.analytics.logEvent(
      name: 'authorTitleHome',
      parameters: <String, dynamic>{
        'id': '$index',
      },
    );
    // mostrarMensaje('logEvent succeeded');
  }

  void _actionButtonFloat() {
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AppPoemas(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: const Center(child: Text("Para agregar un poema debe registrarse o iniciar sesión")),
            actions: <Widget>[
              TextButton(
                child: const Text("Continuar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }
}
