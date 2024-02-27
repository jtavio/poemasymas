import 'package:app_poemas/constants.dart';
import 'package:app_poemas/src/bloc/notification-push/notification_push_bloc.dart';
import 'package:app_poemas/src/pages/notifications/notifications_screen.dart';
import 'package:app_poemas/src/routes/routes.dart';
import 'package:app_poemas/src/views/update_version/updated_version.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'firebase_options.dart';

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
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationPushBloc().onRequestPermission();
  final InStoreAppVersionChecker poemasUpdateChecker;
  poemasUpdateChecker = InStoreAppVersionChecker(
    appId: 'com.apppoemas.poemasymas',
  );
  String? versionNewPoems;
  String? versionPoemsCurrent;
  String? versionCurrent;
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  versionCurrent = packageInfo.version;
  await poemasUpdateChecker.checkUpdate().then((value) {
    versionNewPoems = value.newVersion;
    versionPoemsCurrent = value.currentVersion;
  });
  print('versionNewPoems $versionNewPoems versionPomesCurrent $versionPoemsCurrent');

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
      BlocProvider(create: (context) => NotificationPushBloc())
    ],
    child: MyApp(versionCurrent: versionCurrent, versionNewPoems: versionNewPoems),
  ));
}

class MyApp extends StatefulWidget {
  final String? versionCurrent, versionNewPoems;
  const MyApp({Key? key, this.versionCurrent, this.versionNewPoems}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: Constants.AppName,
      initialRoute: SignIn.routeName,
      theme: ThemeData(
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color?>(Colors.deepOrangeAccent[100]))),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF64FFDA),
          background: const Color(0xFF64FFDA),
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
      home: HomeRouterScreen(versionCurrent: widget.versionCurrent, versionNewPoems: widget.versionNewPoems),
      builder: (context, child) => HandleNotificationsInteractions(navigatorKey: navigatorKey, child: child!),
    );
  }
}

class HomeRouterScreen extends StatefulWidget {
  final String? versionCurrent, versionNewPoems;
  const HomeRouterScreen({
    super.key,
    required this.versionCurrent,
    required this.versionNewPoems,
  });

  @override
  State<HomeRouterScreen> createState() => _HomeRouterScreenState();
}

class _HomeRouterScreenState extends State<HomeRouterScreen> {
  bool isNewVersion(String currentVersion, String newVersion) {
    List<String> currentVersionParts = currentVersion.split('.');
    List<String> newVersionParts = newVersion.split('.');

    for (int i = 0; i < currentVersionParts.length; i++) {
      int currentVersionPart = int.parse(currentVersionParts[i]);
      int newVersionPart = int.parse(newVersionParts[i]);

      if (newVersionPart > currentVersionPart) {
        return true;
      } else if (newVersionPart < currentVersionPart) {
        return false;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return onRedirect(widget.versionCurrent, widget.versionNewPoems);
  }

  onRedirect(String? versionCurrent, String? versionNewPoems) {
    if (isNewVersion(versionCurrent!, versionNewPoems!)) {
      return const UpdateVersionAppScreen();
    } else {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomeAuthors();
          }
          return const SignIn();
        },
      );
    }
  }
}

class HandleNotificationsInteractions extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  const HandleNotificationsInteractions({super.key, required this.child, required this.navigatorKey});

  @override
  State<HandleNotificationsInteractions> createState() => _HandleNotificationsInteractionsState();
}

class _HandleNotificationsInteractionsState extends State<HandleNotificationsInteractions> {
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    context.read<NotificationPushBloc>().handleRemoteMessage(message);

    //if (message.data['type'] == 'chat') {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_navigateToNotificationsScreen();
      //Navigator.pushNamedAndRemoveUntil('notification', (Route<dynamic> route) => false);
      final bottomNavigationBloc = context.read<BottomNavigationBloc>();
      bottomNavigationBloc.add(TapChangeEvent(2));
    });
    //}`
  }

  void _navigateToNotificationsScreen() {
    if (Navigator.canPop(context)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const NotificationsScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
