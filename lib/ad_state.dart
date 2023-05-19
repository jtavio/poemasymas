import 'dart:io';

import 'package:app_poemas/constants.dart';

class AdState {
  static String get bannerUnitId {
    if (Platform.isAndroid) {
      return Constants.bannerAdUnitId; // test unit id
    } else if (Platform.isIOS) {
      return Constants.bannerAdUnitId; // test unit id
    } else {
      throw new UnsupportedError('Unsupported platform');
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
