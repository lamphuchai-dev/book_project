import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/pages/splash/view/extension/extension_model.dart';
import 'package:u_book/pages/splash/view/extensions_manager.dart';
import 'package:u_book/pages/splash/view/runtime.dart';
import 'package:u_book/services/extension_runtime.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/services/storage_service.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
      {required ExtensionsManager extensionsManager,
      required StorageService storageService,
      required this.extensionManager})
      : _extensionsManager = extensionsManager,
        _storageService = storageService,
        super(HomeStateInitial()) {
    _streamSubscription = _extensionsManager.streamExts.listen((exts) async {
      // final state = this.state;

      // if (state is LoadedExtensionState) {
      //   final ext =
      //       _extensionsManager.getExtensionBySource(state.extension.source);
      //   if (ext != null) return;
      //   final exts = _extensionsManager.getExtensions;
      //   if (exts.isEmpty) {
      //     emit(ExtensionNoInstallState());
      //   } else {
      //     _runTime = await _extensionsManager
      //         .getExtensionRuntimeByExtension(exts.first);
      //     emit(LoadedExtensionState(extension: exts.first));
      //   }
      // } else if (state is ExtensionNoInstallState) {
      //   final exts = _extensionsManager.getExtensions;
      //   if (exts.isEmpty) {
      //     emit(ExtensionNoInstallState());
      //   } else {
      //     _runTime = await _extensionsManager
      //         .getExtensionRuntimeByExtension(exts.first);
      //     emit(LoadedExtensionState(extension: exts.first));
      //   }
      // }
    });
  }
  final _logger = Logger("HomeCubit");

  final ExtensionsManager _extensionsManager;
  late ExtensionRunTime? _runTime;
  late StreamSubscription _streamSubscription;
  final StorageService _storageService;
  final ExtensionManager extensionManager;
  late final RunTime runTime;

  ExtensionRunTime? get extRuntime => _runTime;

  void onInit() async {
    try {
      emit(LoadingExtensionState());
      runTime = RunTime();
      runTime.initRuntime();
      final list = extensionManager.getExtensions;
      if (list.isEmpty) {
        emit(ExtensionNoInstallState());
        return;
      }
      emit(LoadedExtensionState(extension: list.first));
      // final exts = _extensionsManager.getExtensions;
      // if (exts.isEmpty) {
      //   emit(ExtensionNoInstallState());
      //   return;
      // }
      // String? sourceExtPrimary =
      //     await _storageService.getSourceExtensionPrimary();
      // sourceExtPrimary ??= exts.first.source;
      // final extRuntime = await _extensionsManager
      //     .getExtensionRunTimeBySource(sourceExtPrimary);
      // if (extRuntime == null) {
      //   _runTime =
      //       await _extensionsManager.getExtensionRuntimeByExtension(exts.first);
      //   await _storageService.setSourceExtensionPrimary(exts.first.source);
      //   emit(LoadedExtensionState(extension: exts.first));
      // } else {
      //   _runTime = extRuntime;
      //   emit(LoadedExtensionState(extension: _runTime!.extension));
      // }
    } catch (error) {
      _logger.error(error);
      emit(ExtensionNoInstallState());
    }
  }

  Future<List<Book>> onGetListBook(String url, int page) async {
    final state = this.state;
    if (state is! LoadedExtensionState) return [];

    try {
      url = "${state.extension.metadata.source}$url";
      final jsScript =
          DirectoryUtils.getJsScriptByPath(state.extension.script.home!);
      return await runTime.listBook(
          url: url,
          page: page,
          jsScript: jsScript,
          extType: state.extension.metadata.type);
    } catch (error) {
      _logger.error(error, name: "onGetListBook");
    }
    return [];
  }

  Future<List<Book>> onSearchBook(String keyWord, int page) async {
    // try {
    //   return await _runTime!.search(keyWord, page);
    // } catch (error) {
    //   _logger.error(error, name: "onGetListBook");
    // }
    return [];
  }

  void onChangeExtensions(ExtensionModel extension) async {
    final state = this.state;
    if (state is! LoadedExtensionState) return;
    emit(LoadingExtensionState());
    await Future.delayed(const Duration(milliseconds: 50));
    // _runTime =
    //     await _extensionsManager.getExtensionRuntimeByExtension(extension);
    // await _storageService.setSourceExtensionPrimary(extension.source);
    emit(LoadedExtensionState(extension: extension));
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
