import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extensions_service.dart';
import 'package:u_book/services/extensions_service.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required ExtensionsService extensionsService})
      : _extensionsService = extensionsService,
        super(const SplashStateInitial());

  final ExtensionsService _extensionsService;
  void onInit() async {
    emit(const LoadingLocalExts());
    await _extensionsService.onInit();
    emit(const LoadedLocalExts());
  }
}
