import 'dart:convert';

import 'package:app_poemas/src/widgets/custom_multiline_text_field.dart';
import 'package:app_poemas/src/widgets/poem_custom_text_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPoemas extends StatefulWidget {
  static const routeName = 'add-poems';
  const AppPoemas({Key? key}) : super(key: key);

  @override
  State<AppPoemas> createState() => _AppPoemasState();
}

class _AppPoemasState extends State<AppPoemas> {
  final TextEditingController _lineStepsController = TextEditingController();
  final List<String> _previewStepsList = [];
  final TextEditingController _recipeNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _lineStepsController.dispose();
    _recipeNameController.dispose();
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      print('hola');
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepOrangeAccent[100]),
                    child: const Text('Añadir Poema'),
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
        content: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemExtent: 40,
          itemCount: previewStepsList.length,
          itemBuilder: (context, index) =>
              stepsListTile(context, index, previewStepsList),
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
            style:
                const TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal),
          ),
        ),
      ],
    ),
  );
}
