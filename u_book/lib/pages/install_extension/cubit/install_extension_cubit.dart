import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'install_extension_state.dart';

class InstallExtensionCubit extends Cubit<InstallExtensionState> {
  InstallExtensionCubit() : super(InstallExtensionInitial());

  void onInit() {}
}
