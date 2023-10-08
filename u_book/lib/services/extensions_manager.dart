import 'dart:convert';

import 'package:dio_client/index.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/services/storage_service.dart';
import 'package:u_book/utils/logger.dart';

class ExtensionsManager {
  ExtensionsManager(
      {required DioClient dioClient,
      required StorageService storageService,
      required DatabaseService databaseService})
      : _dioClient = dioClient,
        _storageService = storageService,
        _databaseService = databaseService;

  final _logger = Logger("ExtensionsManager");

  List<Extension> _extensions = [];
  final DioClient _dioClient;
  final StorageService _storageService;
  final DatabaseService _databaseService;

  ExtensionRunTime? _runTimePrimary;
  Extension? _extensionPrimary;

  List<Extension> get extensions => _extensions;

  Extension? get extensionPrimary => _extensionPrimary;

  ExtensionRunTime? get runTimePrimary => _runTimePrimary;

  Future<void> onInit() async {
    await Future.wait([onLoadExtensions()]);
    if (_runTimePrimary == null && extensions.isNotEmpty) {
      final ext = extensions.firstWhere((element) => element.isPrimary,
          orElse: () => extensions.first);
      await setRunTimePrimary(ext);
    }
  }

  Future<ExtensionRunTime?> setRunTimePrimary(Extension extension) async {
    try {
      List<Extension> extensions = [];
      if (_extensionPrimary != null) {
        final preExt = _extensionPrimary!.copyWith(isPrimary: false);
        extensions.add(preExt);
      }
      _runTimePrimary = ExtensionRunTime();
      if (extension.jsScript == null) {
        final jsScript = await getJsScriptByUrl(extension.script);
        if (jsScript is String) {
          extension = extension.copyWith(jsScript: jsScript);
        }
      }
      extension = extension.copyWith(isPrimary: true);

      final extReady = await _runTimePrimary!.initRuntime(extension);
      if (extReady) {
        extensions.add(extension);
        _databaseService.changeIsPrimaryExtension(extensions);
        _extensionPrimary = extension;
        return _runTimePrimary!;
      }
      return null;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getJsScriptByUrl(String url) async {
    return _dioClient.get(url);
  }

  Future<bool> onLoadExtensions() async {
    try {
      final localExts = await _databaseService.findAllExtensions();
      if (localExts.isEmpty) {
        final exts = await onGetExtensions();
        await _databaseService.insertExtensions(exts);
        return onLoadExtensions();
      } else {
        _extensions = localExts;
        return true;
      }
    } catch (error) {
      _logger.error(error, name: "onLoadExtensions");
    }
    return false;
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
}
