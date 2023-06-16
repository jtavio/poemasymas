import 'package:app_poemas/constants.dart';
import 'package:app_poemas/src/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:app_poemas/src/bloc/simple_bloc_observer.dart';
import 'package:app_poemas/src/data/repositories/auth_repository.dart';
import 'package:app_poemas/src/pages/signin/sign-in.dart';
import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/pages/home_authors.dart';
import 'package:app_poemas/src/services/https_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = SimpleBlocObserver();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthorTitleBloc(httpServices: HttpServices()),
      ),
      BlocProvider(
        create: (context) => AuthBloc(authRepository: AuthRepository()),
      ),
      BlocProvider(
        create: (context) => ThemeBloc(),
      ),
      BlocProvider(
        create: (context) => BottomNavigationBloc(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.AppName,
      initialRoute: SignIn.routeName,
      theme: ThemeData(
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(Colors.deepOrangeAccent[100]))),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF64FFDA),
          background: Color(0xFF64FFDA),
        ),
        //backgroundColor: Colors.grey[100],
        fontFamily: 'Montserrat',
        primaryColor: Colors.deepOrangeAccent[100],
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF64FFDA),
        ),
      ),
      darkTheme: ThemeData.dark(),
      routes: routes,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeAuthors();
          }
          return const SignIn();
        },
      ),
    );
  }
}
