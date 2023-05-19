import 'package:app_poemas/src/pages/home_authors.dart';
import 'package:app_poemas/src/pages/signup/sign_up.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_poemas/src/bloc/blocs.dart';

class SignIn extends StatefulWidget {
  static String routeName = "signin";
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'signing');
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeAuthors()));
          }
          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Loading) {
              // Showing the loading indicator while the user is signing in
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UnAuthenticated) {
              // Showing the sign in form if the user is not authenticated
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Inicia sesión",
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "Email",
                                    border: OutlineInputBorder(),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && !EmailValidator.validate(value)
                                        ? 'Ingrese un email valido'
                                        : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      border: const OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      )),
                                  obscureText: _isObscure,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value != null && value.length < 6 ? "Ingrese un min. de 6 caracteres" : null;
                                  },
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _authenticateWithEmailAndPassword(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepOrangeAccent[100],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 15.0,
                                      ),
                                    ),
                                    child: const Text(
                                      'Iniciar sesión',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            onPressed: () {
                              _authenticateWithGoogle(context);
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 15),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.white),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                                  height: 30,
                                  width: 30,
                                ),
                                const Text('Iniciar sesión con google')
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const Text("No tienes una cuenta?"),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUp()),
                            );
                          },
                          child: const Text(
                            "Registrate",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(HomeAuthors.routeName);
                          },
                          child: const Text(
                            "Continuar como Visitante",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      FirebaseAnalytics.instance.logEvent(name: 'login', parameters: null);

      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}
