import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book_model.dart';
import 'package:u_book/services/extensions_manager.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required ExtensionsManager manager})
      : _manager = manager,
        super(const SplashState(statusType: StatusType.init));

  final ExtensionsManager _manager;
  void onInit() async {
    emit(state.copyWith(statusType: StatusType.loading));
    await _manager.onInit();
    // final tmp = {};
  
    emit(state.copyWith(statusType: StatusType.loaded));
  }
}
