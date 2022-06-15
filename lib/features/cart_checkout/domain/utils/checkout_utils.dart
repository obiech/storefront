import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutUtils {
  /// Open Gojek app if installed on device,
  /// else redirect to playstore for user to install Gojek app
  static Future<void> launchGoPayCheckoutLink(String link) async {
    try {
      final opened = await launch(link);

      if (!opened) {
        throw PlatformException(code: 'ACTIVITY_NOT_FOUND');
      }
    } on PlatformException catch (e) {
      if (e.code == 'ACTIVITY_NOT_FOUND') {
        await launch(
          Platform.isAndroid
              ? 'https://play.google.com/store/apps/details?id=com.gojek.app'
              : 'https://apps.apple.com/us/app/gojek/id944875099',
        );
      }
    }
  }
}
