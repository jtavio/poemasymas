import 'package:app_poemas/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/link.dart';

import 'package:in_app_review/in_app_review.dart';
import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/pages/add-poemas/add_poems.dart';
import 'package:app_poemas/src/pages/signin/sign-in.dart';

class ProfileUser extends StatefulWidget {
  static var routeName = 'profile';

  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final InAppReview inAppReview = InAppReview.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      _controllerEmail.text = user!.email!;
      _controllerName.text = user!.displayName != null ? user!.displayName! : '';
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Mi Cuenta',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: const Color(0xFFFF9E80),
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.exit_to_app_outlined),
                  tooltip: 'home',
                  onPressed: () {
                    context.read<AuthBloc>().add(SignOutRequested());
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is UnAuthenticated) {
                  // Navigate to the sign in screen when the user Signs Out
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const SignIn()),
                    (route) => false,
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user!.photoURL != null
                        ? Center(
                            child: CircleAvatar(
                              radius: 40,
                              child: ClipOval(
                                child: FadeInImage(
                                  image: NetworkImage("${user!.photoURL}"),
                                  placeholder: const AssetImage('assets/images/loading.gif'),
                                ),
                              ),
                            ),
                          )
                        : const Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/images/account.png'),
                              radius: 40,
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Correo: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controllerEmail,
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   'Email: ${user.email}',
                    //   style: const TextStyle(fontSize: 20),
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Nombre: ',
                          style: TextStyle(fontSize: 16),
                        ),
                        user?.displayName != null
                            ? Expanded(
                                child: TextField(
                                  controller: _controllerName,
                                  enabled: false,
                                ),
                              )
                            : const Text(
                                '',
                                style: TextStyle(fontSize: 20),
                              ),
                        // Expanded(
                        //   child: TextField(
                        //     controller: _controllerName,
                        //     enabled: false,
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AppPoemas(),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1.0, color: const Color(0xFFdddddd))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(
                                  Icons.post_add_outlined,
                                  size: 20.0,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Escribir Poemas',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      child: InkWell(
                        onTap: () {
                          inAppReview.openStoreListing(
                              appStoreId: '...', microsoftStoreId: Constants.GooglePlayIdentifier);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1.0, color: const Color(0xFFdddddd))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(Icons.rate_review_outlined, size: 20.0),
                                SizedBox(
                                  width: 15,
                                ),
                                Text('Calificanos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Informacion Legal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Material(
                      child: Link(
                        target: LinkTarget.self,
                        uri: Uri.parse(
                            'https://docs.google.com/document/d/1xhPE0pSVXE87WG24WRMXTmWaYWTkEllm/edit?usp=sharing&ouid=110195874036427963121&rtpof=true&sd=true'),
                        builder: (context, followLink) => InkWell(
                          onTap: followLink,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 1.0, color: const Color(0xFFdddddd))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(Icons.info_outline_rounded, size: 20.0),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text('Politicas de privacidad',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _deleteAcount(context);
                        },
                        child: const Text('Eliminar cuenta'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
    } else {
      return Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Center(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/images/account.png'),
            radius: 60,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text("Ingresa a tu cuenta para gestionar tu perfil, preferencias y más", textAlign: TextAlign.center),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignIn(),
                ),
              ),
              child: const Column(children: [
                Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/account.png'),
                    radius: 20,
                  ),
                ),
                Center(
                  child: Text(
                    "Ingresar",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 15),
        //   child: InkWell(
        //     onTap: () => Navigator.push(context,
        //         MaterialPageRoute(builder: (context) => ContactUsScreen())),
        //     child: listViewItem(
        //         context,
        //         Icon(
        //           Icons.email,
        //           color: Colors.black,
        //         ),
        //         'Contactanos'),
        //   ),
        // )
      ]));
    }
  }

  void _deleteAcount(context) {
    BlocProvider.of<AuthBloc>(context).add(
      DeleteAuth(),
    );
  }
}
