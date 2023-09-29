import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUtils {
  static ensureInitialized() {
    setSystemUIOverlayStyle();
    setPreferredOrientations();
  }

  static setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
  }

  static Future<void> setPreferredOrientations() {
    return SystemChrome.setPreferredOrientations([
      // DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
  }

  static void setSystemNavigationBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ),
    );
  }
}
