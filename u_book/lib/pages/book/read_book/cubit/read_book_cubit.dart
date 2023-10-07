import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/utils/logger.dart';
import 'package:u_book/utils/system_utils.dart';

part 'read_book_state.dart';

class ReadBookCubit extends Cubit<ReadBookState> {
  ReadBookCubit(
      {required this.book,
      required Chapter chapter,
      required ExtensionRunTime extensionRunTime})
      : _extensionRunTime = extensionRunTime,
        _intReadChapter = chapter,
        super(BaseReadBook(chapters: book.chapters));
  final _logger = Logger("ReadBookCubit");

  final Book book;

  final Chapter _intReadChapter;

  final ExtensionRunTime _extensionRunTime;

  bool _currentOnTouchScreen = false;

  late final AnimationController _menuAnimationController;
  late final PageController pageController;

  int indexPageChapter = 0;

  void onInit() {
    pageController = PageController(initialPage: initialPage);
  }

  Chapter get currentChapter => book.chapters[indexPageChapter];

  BookType get bookType => book.type;

  // onTap vào màn hình để mở panel theo [ReadBookType]
  void onTapScreen() {
    if (_isShowMenu || _currentOnTouchScreen) return;
    onChangeIsShowMenu(true);
    _currentOnTouchScreen = false;
  }

  void setMenuAnimationController(AnimationController animationController) {
    _menuAnimationController = animationController;
  }

  void onToPageByChapter(Chapter chapter) {
    final index = book.chapters.indexOf(chapter);
    onToPageByIndex(index);
  }

  void onToPageByIndex(int index) {
    pageController.jumpToPage(index);
  }

  bool get _isShowMenu =>
      _menuAnimationController.status == AnimationStatus.completed;

  // chạm vào màn hình để đọc, ẩn panel nếu đang được hiện thị
  void onTouchScreen() async {
    _currentOnTouchScreen = false;
    if (!_isShowMenu) return;
    onChangeIsShowMenu(false);
    _currentOnTouchScreen = true;
  }

  void onChangeIsShowMenu(bool value) async {
    if (value) {
      _menuAnimationController.forward();
    } else {
      _menuAnimationController.reverse();
    }
  }

  int get initialPage {
    final index = book.chapters.indexOf(_intReadChapter);
    indexPageChapter = index;

    return index == -1 ? 0 : index;
  }

  void onPageChanged(int index) {
    indexPageChapter = index;
    _logger.log("onPageChanged :: $index");
  }

  Future<void> onHideCurrentMenu() async {
    if (_menuAnimationController.status == AnimationStatus.completed) {
      await _menuAnimationController.reverse();
    }
  }

  void onEnableAutoScroll() async {
    await onHideCurrentMenu();
    emit(AutoScrollReadBook(
      chapters: state.chapters,
      timerScroll: 10,
      scrollStatus: AutoScrollStatus.start,
    ));
  }

  void onCloseAutoScroll() async {
    final state = this.state;
    if (state is AutoScrollReadBook) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.stop));
    }
    await onHideCurrentMenu();
    emit(BaseReadBook(chapters: state.chapters));
  }

  void onChangeTimerScroll(double value) {
    final state = this.state;
    if (state is AutoScrollReadBook) {
      emit(state.copyWith(timerScroll: value));
    }
  }

  void onPauseAutoScroll() {
    final state = this.state;
    if (state is AutoScrollReadBook) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.pause));
    }
  }

  void onPlayAutoScroll() {
    final state = this.state;
    if (state is AutoScrollReadBook) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.start));
    }
  }

  void onAutoScrollNexPage() {
    final state = this.state;
    if (state is AutoScrollReadBook) {
      emit(state.copyWith(scrollStatus: AutoScrollStatus.stop));

      if (indexPageChapter + 1 < state.chapters.length) {
        pageController.jumpToPage(indexPageChapter + 1);
        emit(state.copyWith(scrollStatus: AutoScrollStatus.start));
      } else {
        onCloseAutoScroll();
      }
    }
  }

  ScrollPhysics? getPhysicsScroll() {
    if (state is BaseReadBook || state is ReadBookInitial) {
      return const ClampingScrollPhysics();
    }
    return const NeverScrollableScrollPhysics();
  }

  @override
  Future<void> close() {
    SystemUtils.setEnabledSystemUIModeDefault();
    _menuAnimationController.dispose();
    pageController.dispose();
    return super.close();
  }
}
