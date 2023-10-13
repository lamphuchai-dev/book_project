import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/extensions_manager.dart';

part 'install_extension_state.dart';

class InstallExtensionCubit extends Cubit<InstallExtensionState> {
  InstallExtensionCubit({required ExtensionsManager extensionsManager})
      : _extensionsManager = extensionsManager,
        super(InstallExtensionState(
            installedExts: extensionsManager.getExtensions,
            notInstalledExts: const [],
            statusType: StatusType.init)) {
    _streamSubscription = _extensionsManager.streamExts.listen((exts) {
      emit(state.copyWith(installedExts: exts));
    });
  }

  final ExtensionsManager _extensionsManager;
  late StreamSubscription? _streamSubscription;

  bool fromToHome = false;

  void onInit() async {
    if (state.installedExts.isNotEmpty) {
      fromToHome = true;
    }
    final list = await _extensionsManager.onGetExtensions();
    emit(state.copyWith(notInstalledExts: list));
  }

  Future<bool> onInstallExt(Extension extension) async {
    final isInstallExt = await _extensionsManager.installExtension(extension);
    if (isInstallExt) {
      final exts = state.notInstalledExts;
      final noIn = exts.where((ext) => ext.source != extension.source).toList();
      emit(state.copyWith(notInstalledExts: noIn));
    }
    return isInstallExt;
  }

  Future<bool> onUninstallExt(Extension extension) async {
    final result = await _extensionsManager.uninstallExtension(extension);
    return result;
  }

  List<Extension> getListExts() {
    List<Extension> notInstalledExts = state.notInstalledExts;
    for (var ext in state.installedExts) {
      notInstalledExts =
          notInstalledExts.where((e) => e.source != ext.source).toList();
    }
    return notInstalledExts;
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
