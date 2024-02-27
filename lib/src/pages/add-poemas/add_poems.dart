// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:app_poemas/src/bloc/blocs.dart';
import 'package:app_poemas/src/widgets/custom_multiline_text_field.dart';
import 'package:app_poemas/src/widgets/poem_custom_text_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPoemas extends StatefulWidget {
  static const routeName = '/add-poems';

  const AppPoemas({Key? key}) : super(key: key);

  @override
  State<AppPoemas> createState() => _AppPoemasState();
}

class _AppPoemasState extends State<AppPoemas> {
  final TextEditingController _lineStepsController = TextEditingController();
  final List<String> _previewStepsList = [];
  final TextEditingController _recipeNameController = TextEditingController();
  AuthorTitleBloc? addPoem;
  final user = FirebaseAuth.instance.currentUser;
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future addPoems() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    String capitalize(String? s) => s![0].toUpperCase() + s.substring(1);
    if (_recipeNameController.value.text.isNotEmpty && _lineStepsController.value.text.isNotEmpty) {
      LineSplitter ls = const LineSplitter();
      List<String> lines = ls.convert(_lineStepsController.value.text);
      final docData = <String, dynamic>{
        'title': capitalize(_recipeNameController.value.text),
        'lineas': lines,
        'author': user?.displayName,
        'likes': 0,
        'idfcm': fcmToken,
        'uidUser': user?.uid,
      };
      debugPrint('docData $docData');
      bool res = await addPoem!.addPoemsAuthor(docData);
      res
          ? CherryToast.success(
              title: const Text(
                "Procesado con exito!!",
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ).show(context)
          : CherryToast.error(
              title: const Text(
                'En este momento no podemos procesar la solicitud, Por favor intente mas tarde agregar un poema',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ).show(context);
      _recipeNameController.clear();
      _lineStepsController.clear();
    } else {
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(255, 255, 225, 229),
          content: Text(
            'Por favor completa todos los campos',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    analytics.setCurrentScreen(screenName: 'AddPoems', screenClassOverride: 'AddPoems');
    addPoem = BlocProvider.of<AuthorTitleBloc>(context);
  }

  @override
  void dispose() {
    _lineStepsController.dispose();
    _recipeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Nuevo Poema',
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF9E80),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => const ProfileUser(),
        //     ),
        //   ),
        // ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                PoemCustomTextField(
                  label: 'Titulo del poema*',
                  controller: _recipeNameController,
                  textInputType: TextInputType.text,
                  textInputFormatter: null,
                ),
                CustomMultiLineTextField(
                  controller: _lineStepsController,
                  label: 'Lineas',
                  function: () async {
                    await _previewLines(_lineStepsController);
                    _showPreviewDialog("Versos", _previewStepsList);
                  },
                  placeholder: "versos",
                ),
                //Text('${_previewStepsList.length}'),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    addPoems();
                    await _registerEventAnalyticsAddPoems(_recipeNameController.value.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent[100],
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text(
                    'Añadir Poema',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPreviewDialog(String label, List<String> previewStepsList) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(bottom: 20),
        title: Text(
          '$label Preview',
          style: const TextStyle(fontSize: 16),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemExtent: 50,
            itemCount: previewStepsList.length,
            itemBuilder: (context, index) => stepsListTile(context, index, previewStepsList),
          ),
        ),
      ),
    );
  }

  _previewLines(TextEditingController controller) {
    _previewStepsList.clear();
    LineSplitter ls = const LineSplitter();
    List<String> lines = ls.convert(controller.value.text);
    for (var i = 0; i < lines.length; i++) {
      _previewStepsList.add(lines[i]);
    }
  }

  Future _registerEventAnalyticsAddPoems(String value) async {
    await analytics.logEvent(
      name: 'addPoem',
      parameters: <String, dynamic>{
        'title': value,
      },
    );
    // mostrarMensaje('logEvent succeeded');
  }
}

Widget stepsListTile(BuildContext context, int index, List items) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    child: Row(
      children: <Widget>[
        AutoSizeText(
          '${index + 1}.',
          // style: GoogleFonts.pacifico(),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: AutoSizeText(
            '"${items[index]}"',
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ),
  );
}
