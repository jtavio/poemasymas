import 'dart:io';

import 'package:app_poemas/constants.dart';

class AdState {
  static String get bannerUnitId {
    if (Platform.isAndroid) {
      return Constants.bannerAdUnitId; // test unit id
    } else {
      return Constants.bannerAdUnitId; // test unit id
    }
  }

  static String get bannerProdId {
    if (Platform.isAndroid) {
      return Constants.AppId; // test unit id
    } else {
      return Constants.AppId; // test unit id
    }
  }
}
