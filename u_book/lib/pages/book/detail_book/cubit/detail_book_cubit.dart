import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/utils/logger.dart';

part 'detail_book_state.dart';

class DetailBookCubit extends Cubit<DetailBookState> {
  DetailBookCubit(
      {required Book book, required ExtensionRunTime extensionRunTime})
      : _extensionRunTime = extensionRunTime,
        super(DetailBookState(book: book, statusType: StatusType.init));

  final _logger = Logger("DetailBookCubit");

  final ExtensionRunTime _extensionRunTime;
  void onInit() async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));
      final result = await _extensionRunTime.detail(state.book.bookUrl);
      emit(state.copyWith(book: result, statusType: StatusType.loaded));
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

}
