import 'dart:convert';

import 'package:dio_client/index.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/services/storage_service.dart';
import 'package:u_book/utils/logger.dart';

class ExtensionsManager {
  ExtensionsManager(
      {required DioClient dioClient, required StorageService storageService})
      : _dioClient = dioClient,
        _storageService = storageService;

  final _logger = Logger("ExtensionsManager");

  List<Extension> _extensions = [];
  final DioClient _dioClient;
  final StorageService _storageService;

  ExtensionRunTime? _runTimePrimary;

  List<Extension> get extensions => _extensions;

  ExtensionRunTime? get runTimePrimary => _runTimePrimary;

  Future<void> onInit() async {
    await Future.wait([onLoadExtensions(), loadExtensionPrimary()]);
    if (_runTimePrimary == null && extensions.isNotEmpty) {
      await setRunTimePrimary(extensions.first);
    }
  }

  Future<ExtensionRunTime> setRunTimePrimary(Extension extension) async {
    _runTimePrimary = ExtensionRunTime();
    _storageService.setExtension(extension);
    await _runTimePrimary!.initRuntime(extension);
    return _runTimePrimary!;
  }

  Future<bool> onLoadExtensions() async {
    try {
      final localExts = await _storageService.getListExtension();
      if (localExts.isEmpty) {
        final exts = await onGetExtensions();
        _extensions = exts;
        return true;
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

  Future<void> loadExtensionPrimary() async {
    _logger.log("loadExtensionPrimary");
    final localExt = await _storageService.getExtension();
    if (localExt != null) {
      await setRunTimePrimary(localExt);
    }
  }

  
}
