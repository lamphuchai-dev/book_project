part of 'read_book_cubit.dart';

abstract class ReadBookState extends Equatable {
  const ReadBookState({required this.chapters});
  final List<Chapter> chapters;

  @override
  List<Object> get props => [chapters];
}

class ReadBookInitial extends ReadBookState {
  const ReadBookInitial({required super.chapters});
}

class BaseReadBook extends ReadBookState {
  const BaseReadBook({required super.chapters});

  BaseReadBook copyWith({List<Chapter>? chapters}) {
    return BaseReadBook(chapters: chapters ?? this.chapters);
  }

  @override
  List<Object> get props => [chapters];
}

class AutoScrollReadBook extends ReadBookState {
  const AutoScrollReadBook({
    required super.chapters,
    required this.timerScroll,
    required this.scrollStatus,
  });
  final double timerScroll;
  final AutoScrollStatus scrollStatus;

  AutoScrollReadBook copyWith(
      {double? timerScroll,
      List<Chapter>? chapters,
      AutoScrollStatus? scrollStatus,
      bool? isShowMenu}) {
    return AutoScrollReadBook(
        chapters: chapters ?? this.chapters,
        timerScroll: timerScroll ?? this.timerScroll,
        scrollStatus: scrollStatus ?? this.scrollStatus);
  }

  @override
  List<Object> get props => [chapters, timerScroll, scrollStatus];
}
