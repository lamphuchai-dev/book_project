import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/pages/splash/view/extensions_manager.dart';
import 'package:u_book/services/extensions_manager.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required ExtensionsManager manager})
      : _manager = manager,
        super(const SplashStateInitial());

  final ExtensionsManager _manager;
  void onInit() async {
    emit(const LoadingLocalExts());

    // await _manager.onLoadLocalExtensions();
    await getIt<ExtensionManager>().onInit();

    // if (_manager.getExtensions.isNotEmpty) {
    //   emit(const LoadedLocalExts());
    // } else {
    //   emit(const LocalExtsEmpty());
    // }
    emit(const LoadedLocalExts());
  }
}
