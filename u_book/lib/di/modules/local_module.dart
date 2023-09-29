import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalModule {
  static Future<SharedPreferences> provideSharedPreferences() {
    return SharedPreferences.getInstance();
  }

  static FlutterSecureStorage provideSecureStorage() {
    return const FlutterSecureStorage();
  }
}
