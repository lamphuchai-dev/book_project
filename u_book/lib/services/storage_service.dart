import 'package:hive_flutter/adapters.dart';
import 'package:isar/isar.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';

class StorageService {
  final _logger = Logger("BookStorage");
  late final Isar database;
  late final Box settings;
  late String _path;

  Future<void> ensureInitialized() async {
    _path = await DirectoryUtils.getDirectory;
    await Hive.initFlutter(_path);
    settings = await Hive.openBox("settings");

    _initSettings();
  }

  Future<void> _initSettings() async {
    _logger.log(_path);
  }

  Future<void> _initSetting(String key, dynamic value) async {
    if (!settings.containsKey(key)) {
      await settings.put(key, value);
    }
  }

  Future<void> setSetting(String key, dynamic value) async {
    await settings.put(key, value);
  }

  dynamic getSetting(String key) {
    return settings.get(key);
  }

  void setExtension(Extension extension) async {
    await settings.put(SettingKey.extension, extension.toMap());
  }

  Future<Extension?> getExtension() async {
    final ext = await settings.get(SettingKey.extension);
    if (ext == null) return null;
    return Extension.fromMap(ext.cast<String, dynamic>());
  }

  void setListExtension(List<Extension> extensions) async {
    final list = extensions.map((e) => e.toMap()).toList();
    await settings.put(SettingKey.listExtension, list);
  }

  Future<List<Extension>> getListExtension() async {
    final exts = await settings.get(SettingKey.listExtension);
    if (exts == null) return [];
    return (exts as List)
        .map<Extension>(
            (ext) => Extension.fromMap((ext as Map).cast<String, dynamic>()))
        .toList();
  }
}

class SettingKey {
  static String theme = "Theme";
  static String extension = "Extension";
  static String listExtension = "ListExtension";
}
