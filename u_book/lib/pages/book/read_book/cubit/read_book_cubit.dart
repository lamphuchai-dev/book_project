import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/pages/book/read_book/read_book.dart';
import 'package:u_book/pages/home/cubit/home_cubit.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extension_runtime.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/utils/logger.dart';
import 'package:u_book/utils/system_utils.dart';
part 'read_book_state.dart';

class ReadBookCubit extends Cubit<ReadBookState> {
  ReadBookCubit(
      {required ReadBookArgs readBookArgs,
      required ExtensionsManager extensionsManager,
      required DatabaseService databaseService})
      : _readBookArgs = readBookArgs,
        _extensionsManager = extensionsManager,
        _databaseService = databaseService,
        super(ReadBookInitial(
            totalChapters: readBookArgs.chapters.length,
            extensionStatus: ExtensionStatus.init));
  final _logger = Logger("ReadBookCubit");

  Book get book => _readBookArgs.book;

  late final ExtensionRunTime _extensionRunTime;

  final ReadBookArgs _readBookArgs;
  final ExtensionsManager _extensionsManager;
  final DatabaseService _databaseService;
  bool _currentOnTouchScreen = false;

  late final AnimationController _menuAnimationController;
  PageController? pageController;

  int indexPageChapter = 0;

  List<Chapter> chapters = [];

  ValueNotifier<Chapter?> readChapter = ValueNotifier(null);
  ValueNotifier<ContentPagination?> contentPaginationValue =
      ValueNotifier(null);

  void onInit() async {
    final ext = await _extensionsManager.getExtensionRunTimeBySource(book.host);
    if (ext == null) {
      emit(ReadBookInitial(
          totalChapters: _readBookArgs.chapters.length,
          extensionStatus: ExtensionStatus.error));
      return;
    }

    _extensionRunTime = ext;

    if (_readBookArgs.fromBookmarks) {
      final list = await _extensionRunTime.getChapters(book.bookUrl);
      chapters = list;

      final initReadChapter = chapters
          .firstWhereOrNull((item) => item.index == _readBookArgs.readChapter);
      readChapter.value = initReadChapter ?? chapters.first;
      pageController = PageController(
          initialPage:
              initReadChapter != null ? chapters.indexOf(initReadChapter) : 0);
      emit(BaseReadBook(totalChapters: state.totalChapters));
    } else {
      chapters = _readBookArgs.chapters;
      readChapter.value = chapters[initialPage];
      pageController = PageController(initialPage: initialPage);
      emit(BaseReadBook(totalChapters: state.totalChapters));
    }
  }

  Chapter get currentChapter => chapters[indexPageChapter];

  BookType get bookType => book.type;

  Future<Chapter> getChapterContent(Chapter chapter) async {
    try {
      final content = chapters.firstWhereOrNull(
          (item) => item.index == chapter.index && item.content.isNotEmpty);
      if (content != null) return content;
      List<String> result = await _extensionRunTime.chapter(chapter.url);
      chapter = chapter.copyWith(content: result);
      chapters = chapters
          .map((element) => element.index == chapter.index ? chapter : element)
          .toList();
      return chapter;
    } catch (error) {
      _logger.log(error, name: "getChapterContent");
      rethrow;
    }
  }

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
    final index = chapters.indexOf(chapter);
    onToPageByIndex(index);
  }

  void onToPageByIndex(int index) {
    pageController?.jumpToPage(index);
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
    // final index = chapters.indexOf(_intReadChapter);
    indexPageChapter = _readBookArgs.readChapter ?? 0;

    return indexPageChapter == -1 ? 0 : indexPageChapter;
  }

  void onPageChanged(int index) {
    indexPageChapter = index;
    readChapter.value = chapters[index];
    _logger.log("onPageChanged :: $index");
    if (book.bookmark) {
      _databaseService.updateBook(book.copyWith(
          updateAt: DateTime.now(),
          currentReadChapter: readChapter.value!.index));
    }
  }

  Future<void> onHideCurrentMenu() async {
    if (_menuAnimationController.status == AnimationStatus.completed) {
      await _menuAnimationController.reverse();
    }
  }

  void onEnableAutoScroll() async {
    await onHideCurrentMenu();
    emit(AutoScrollReadBook(
      totalChapters: chapters.length,
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
    emit(BaseReadBook(totalChapters: chapters.length));
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
      if (indexPageChapter + 1 < chapters.length) {
        pageController?.jumpToPage(indexPageChapter + 1);
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

  void setContentPagination(ContentPagination contentPagination) {
    contentPaginationValue.value = contentPagination;
  }

  @override
  Future<void> close() {
    SystemUtils.setEnabledSystemUIModeDefault();
    _menuAnimationController.dispose();
    readChapter.dispose();
    pageController?.dispose();
    contentPaginationValue.dispose();
    return super.close();
  }
}

class ContentPagination {
  final int totalPage;
  final int currentPage;
  final double sliderValue;
  ContentPagination(
      {required this.totalPage,
      required this.currentPage,
      required this.sliderValue});

  String get formatText => "$currentPage/$totalPage";

  int get remainingPages => totalPage - currentPage;

  ContentPagination copyWith({
    int? totalPage,
    int? currentPage,
    double? sliderValue,
  }) {
    return ContentPagination(
        totalPage: totalPage ?? this.totalPage,
        currentPage: currentPage ?? this.currentPage,
        sliderValue: sliderValue ?? this.sliderValue);
  }

  @override
  String toString() =>
      'ContentPagination(totalPage: $totalPage, currentPage: $currentPage)';
}
