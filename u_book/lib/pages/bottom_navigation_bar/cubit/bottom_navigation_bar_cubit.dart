import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit()
      : super(const BottomNavigationBarState(indexSelected: 0));

  void onInit() {}

  void onChangeIndexSelected(int index) {
    emit(state.copyWith(indexSelected: index));
  }
}
