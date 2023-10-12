import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/services/database_service.dart';

part 'bookmarks_state.dart';

class BookmarksCubit extends Cubit<BookmarksState> {
  BookmarksCubit({required DatabaseService databaseService})
      : _databaseService = databaseService,
        super(const BookmarksState(books: [], statusType: StatusType.init)) {
    _booksSubscription = _databaseService.bookStream.listen((event) {
      onInit();
    });
  }

  final DatabaseService _databaseService;

  late StreamSubscription _booksSubscription;
  void onInit() async {
    try {
      emit(state.copyWith(statusType: StatusType.loading));

      final books = await _databaseService.getBooks();

      emit(state.copyWith(statusType: StatusType.loaded, books: books));
    } catch (error) {
      emit(state.copyWith(statusType: StatusType.error));
    }
  }

  @override
  Future<void> close() {
    _booksSubscription.cancel();
    return super.close();
  }
}
