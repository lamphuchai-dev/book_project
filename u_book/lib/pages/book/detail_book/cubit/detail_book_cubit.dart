import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/services/extension_service.dart';
import 'package:u_book/utils/logger.dart';

part 'detail_book_state.dart';

class DetailBookCubit extends Cubit<DetailBookState> {
  DetailBookCubit(
      {required Book book, required ExtensionService extensionService})
      : _extensionService = extensionService,
        super(DetailBookState(book: book, statusType: StatusType.init));

  final _logger = Logger("DetailBookCubit");

  final ExtensionService _extensionService;
  void onInit() async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));
      final result = await _extensionService.detail(state.book.bookUrl);
      emit(state.copyWith(book: result, statusType: StatusType.loaded));
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

}
