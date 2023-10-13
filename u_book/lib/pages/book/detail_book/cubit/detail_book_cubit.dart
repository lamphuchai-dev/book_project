import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extension_runtime.dart';
import 'package:u_book/utils/logger.dart';

part 'detail_book_state.dart';

class DetailBookCubit extends Cubit<DetailBookState> {
  DetailBookCubit(
      {required Book book,
      required  this.extensionRunTime,
      required DatabaseService databaseService})
      : _databaseService = databaseService,
        
        super(DetailBookState(
            book: book, statusType: StatusType.init, isBookmark: false));

  final _logger = Logger("DetailBookCubit");

  final ExtensionRunTime extensionRunTime;
  final DatabaseService _databaseService;
  int? _idBook;
  void onInit() async {
    await Future.wait([getDetailBook(), getBookInBookmarks()]);
  }

  Future<void> getDetailBook() async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));
      final result = await extensionRunTime.detail(state.book.bookUrl);
      emit(state.copyWith(book: result, statusType: StatusType.loaded));
    } catch (error) {
      _logger.error(error, name: "onInit");
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

  Future<void> getBookInBookmarks() async {
    final bookmark = await _databaseService.getBookByUrl(state.book.bookUrl);
    if (bookmark != null) {
      _idBook = bookmark.id;
    }
    emit(state.copyWith(isBookmark: bookmark != null));
  }

  void actionBookmark() async {
    if (state.isBookmark) {
      final isDelete = await _databaseService.deleteExtension(_idBook!);
      if (isDelete) {
        emit(state.copyWith(isBookmark: false));
      }
    } else {
      final idBook = await _databaseService.onInsertBook(state.book);
      if (idBook is int) {
        emit(state.copyWith(isBookmark: true));
        _idBook = idBook;
      }
    }
  }
}
