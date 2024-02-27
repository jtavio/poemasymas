import 'package:flutter/material.dart';

import 'package:open_store/open_store.dart';

class UpdateVersionAppScreen extends StatefulWidget {
  const UpdateVersionAppScreen({
    super.key,
  });

  @override
  State<UpdateVersionAppScreen> createState() => _UpdateVersionAppScreenState();
}

class _UpdateVersionAppScreenState extends State<UpdateVersionAppScreen> {
  onLogin() async {
    OpenStore.instance.open(
      //appStoreId: Constants.storeIdIos,
      androidAppBundleId: 'com.apppoemas.poemasymas',
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              //title: const Text('Título del Modal'),
              content: const Text(
                '¡No te quedes atrás! Actualiza la app ahora mismo para disfrutar de funciones mejoradas.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  //height: 24.0.toFigmaHeight(14)
                ),
                textAlign: TextAlign.center,
              ),

              actions: [
                Center(
                    child: MaterialButton(
                  color: const Color.fromARGB(255, 82, 209, 171),
                  onPressed: onLogin,
                  child: const Text(
                    'Actualizar',
                    style: TextStyle(fontSize: 16),
                  ),
                )),
              ],
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: const Center(child: SizedBox()),
      ),
    );
  }
}
