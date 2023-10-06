import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/data/models/book.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  ChaptersCubit({required Book book}) : super(ChaptersState(book: book));

  void onInit() {
    onSortChapters();
  }

  void onSortChapters() {
    final chapters = state.book.chapters;
    chapters.sort((a, b) => a.index.compareTo(b.index));
    emit(state.copyWith(book: state.book.copyWith(chapters: chapters)));
  }
}
