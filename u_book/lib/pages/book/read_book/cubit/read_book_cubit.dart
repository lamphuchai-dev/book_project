import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'read_book_state.dart';

class ReadBookCubit extends Cubit<ReadBookState> {
  ReadBookCubit() : super(ReadBookInitial());

  void onInit() {}
}
