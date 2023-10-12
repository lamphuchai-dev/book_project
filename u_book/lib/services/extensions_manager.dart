import 'dart:async';
import 'dart:convert';

import 'package:dio_client/index.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/utils/logger.dart';

class ExtensionsManager {
  ExtensionsManager(
      {required DioClient dioClient, required DatabaseService databaseService})
      : _dioClient = dioClient,
        _databaseService = databaseService;

  final _logger = Logger("ExtensionsManager");

  late Map<String, ExtensionRunTime> _extsRuntime;

  final DioClient _dioClient;
  final DatabaseService _databaseService;

  final StreamController<Map<String, ExtensionRunTime>>
      _changeExtsStreamController = StreamController.broadcast();

  Future<void> onInit() async {}

  void streamExtensions() {
    _databaseService.database.extensions.watchLazy().listen((event) {});
  }

  Stream<Map<String, ExtensionRunTime>> get streamExts =>
      _changeExtsStreamController.stream;

  Stream<void> get extensionsChange => _databaseService.extensionsChange;
// 286984166
  Future<void> onLoadLocalExtensions() async {
    try {
      late Map<String, ExtensionRunTime> localExtsRuntime = {};
      final localExts = await _databaseService.getExtensions();
      await Future.forEach(localExts, (ext) async {
        await Future.delayed(const Duration(seconds: 1));
        final extRuntime = ExtensionRunTime();
        final isReady = await extRuntime.initRuntime(ext);
        if (!isReady) return;
        localExtsRuntime[ext.source] = extRuntime;
      });
      _extsRuntime = localExtsRuntime;
      _changeExtsStreamController.add(_extsRuntime);
    } catch (error) {
      _logger.log(error, name: "onLoadLocalExtensions");
    }
  }

  void delete(String source) {
    if (_extsRuntime.containsKey(source)) {
      _extsRuntime.remove(source);
    }
  }

  ExtensionRunTime? getExtensionRunTimeBySource(String source) =>
      _extsRuntime[source];

  Future<ExtensionRunTime?> getExtensionRunTimeBySourceTmp(
      Extension extension) async {
    final extRuntime = ExtensionRunTime();
    final isReady = await extRuntime.initRuntime(extension);
    return extRuntime;
  }

  List<Extension> get getExtensions =>
      _extsRuntime.values.map((e) => e.extension).toList();

  Future<dynamic> getJsScriptByUrl(String url) async {
    return _dioClient.get(url);
  }

  Future<List<Extension>> onGetExtensions() async {
    try {
      final result = await _dioClient.get(
          "https://raw.githubusercontent.com/lamphuchai-dev/book_project/main/ext-book/extensions.json");
      if (result is String) {
        final listJson = jsonDecode(result);
        final exts =
            listJson.map<Extension>((e) => Extension.fromMap(e)).toList();
        return exts;
      }
    } catch (error) {
      _logger.error(error, name: "onGetExtensions");
    }
    return [];
  }

  Future<Extension?> installExtension(Extension extension) async {
    try {
      final checkHostExt = await _dioClient.get(extension.source);
      final jsScriptByExt = await _dioClient.get(extension.script);
      extension = extension.copyWith(jsScript: jsScriptByExt);
      final result = await _databaseService.addExtension(extension);
      if (result is int) {
        extension = extension.copyWith(id: result);
        final extRuntime = ExtensionRunTime();
        final isReady = await extRuntime.initRuntime(extension);
        if (!isReady) return null;
        _extsRuntime[extension.source] = extRuntime;
        _changeExtsStreamController.add(_extsRuntime);
        return extension;
      }
    } catch (error) {
      _logger.log(error, name: "installExtension");
    }
    return null;
  }

  Future<bool> uninstallExtension(Extension extension) async {
    try {
      if (_extsRuntime.containsKey(extension.source)) {
        _extsRuntime.remove(extension.source);
      }
      _changeExtsStreamController.add(_extsRuntime);
      return _databaseService.deleteExtension(extension.id!);
    } catch (error) {
      _logger.log(error, name: "installExtension");
    }
    return false;
  }

  close() {
    _changeExtsStreamController.close();
  }
}
