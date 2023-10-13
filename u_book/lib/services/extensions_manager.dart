import 'dart:async';
import 'dart:convert';
import 'package:dio_client/index.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extension_runtime.dart';
import 'package:u_book/utils/logger.dart';

class ExtensionsManager {
  ExtensionsManager(
      {required DioClient dioClient, required DatabaseService databaseService})
      : _dioClient = dioClient,
        _databaseService = databaseService;

  final _logger = Logger("ExtensionsManager");

  final DioClient _dioClient;
  final DatabaseService _databaseService;

  final StreamController<List<Extension>> _extensionsStreamController =
      StreamController.broadcast();

  List<Extension> _extensions = [];

  List<Extension> get getExtensions => _extensions;

  Stream<List<Extension>> get streamExts => _extensionsStreamController.stream;

  Stream<void> get extensionsChange => _databaseService.extensionsChange;
  Future<void> onLoadLocalExtensions() async {
    try {
      _extensions = await _databaseService.getExtensions();
      _extensionsStreamController.add(_extensions);
    } catch (error) {
      _logger.log(error, name: "onLoadLocalExtensions");
    }
  }

  Extension? getExtensionBySource(String source) {
    return _extensions.firstWhereOrNull((ext) => ext.source == source);
  }

  Future<ExtensionRunTime?> getExtensionRuntimeByExtension(
      Extension extension) async {
    final extRuntime = ExtensionRunTime();
    final isReady = await extRuntime.initRuntime(extension);
    if (isReady) {
      return extRuntime;
    }
    return null;
  }

  Future<ExtensionRunTime?> getExtensionRunTimeBySource(String source) async {
    final ext = getExtensionBySource(source);
    if (ext != null) {
      return getExtensionRuntimeByExtension(ext);
    }
    return null;
  }

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

  Future<bool> installExtension(Extension extension) async {
    try {
      final checkHostExt = await _dioClient.get(extension.source);
      final jsScriptByExt = await _dioClient.get(extension.script);
      extension = extension.copyWith(jsScript: jsScriptByExt);
      final result = await _databaseService.addExtension(extension);
      if (result is int) {
        extension = extension.copyWith(id: result);
        final extRuntime = ExtensionRunTime();
        final isReady = await extRuntime.initRuntime(extension);
        if (!isReady) return isReady;
        _extensions.add(extension);
        _extensionsStreamController.add(_extensions);
        return true;
      }
    } catch (error) {
      _logger.log(error, name: "installExtension");
    }
    return false;
  }

  Future<bool> uninstallExtension(Extension extension) async {
    try {
      final isDelete = await _databaseService.deleteExtension(extension.id!);
      if (isDelete) {
        final exts =
            _extensions.where((ext) => ext.id != extension.id).toList();
        _extensions = exts;
        _extensionsStreamController.add(exts);
      }
      return isDelete;
    } catch (error) {
      _logger.log(error, name: "installExtension");
    }
    return false;
  }

  close() {
    _extensionsStreamController.close();
  }
}
