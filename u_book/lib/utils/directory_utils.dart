// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class DirectoryUtils {
  static Future<String> get getDirectory async {
    final directory = await getApplicationDocumentsDirectory();
    return _appDir(directory);
  }

  static Future<String> get getCacheDirectory async {
    final directory = await getTemporaryDirectory();
    return _appDir(directory);
  }

  static String _appDir(Directory directory) {
    final dir = path.join(directory.path, 'h_book');
    Directory(dir).createSync(recursive: true);
    return dir;
  }
}
