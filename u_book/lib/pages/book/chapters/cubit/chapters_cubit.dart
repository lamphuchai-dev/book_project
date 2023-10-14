import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/services/js_runtime.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit(
      {required this.book,
      required this.extensionModel,
      required JsRuntime jsRuntime})
      : _jsRuntime = jsRuntime,
        super(const ChaptersState(chapters: [], statusType: StatusType.init));
  final _logger = Logger("ChaptersCubit");
  final Book book;
  final JsRuntime _jsRuntime;

  final Extension extensionModel;

  void onInit() async {
    emit(state.copyWith(statusType: StatusType.loading));
    try {
      final chapters = await _jsRuntime.getChapters(
          url: book.bookUrl,
          jsScript:
              DirectoryUtils.getJsScriptByPath(extensionModel.script.chapters));
      emit(state.copyWith(statusType: StatusType.loaded, chapters: chapters));
    } catch (error) {
      emit(state.copyWith(statusType: StatusType.error));
      _logger.error(error, name: "onInit");
    }
  }
}
