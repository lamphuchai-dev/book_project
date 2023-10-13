import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/services/extension_runtime.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/utils/logger.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit({required this.book, required this.extensionRunTime})
      : super(const ChaptersState(chapters: [], statusType: StatusType.init));
  final _logger = Logger("ChaptersCubit");
  final Book book;

  final ExtensionRunTime extensionRunTime;

  void onInit() async {
    emit(state.copyWith(statusType: StatusType.loading));
    try {
      final chapters = await extensionRunTime.getChapters(book.bookUrl);
      emit(state.copyWith(statusType: StatusType.loaded, chapters: chapters));
    } catch (error) {
      emit(state.copyWith(statusType: StatusType.error));
      _logger.error(error, name: "onInit");
    }
  }

  void onSortChapters() {
    // final chapters = state.book.chapters;
    // chapters.sort((a, b) => a.index.compareTo(b.index));
    // emit(state.copyWith(book: state.book.copyWith(chapters: chapters)));
  }
}
