import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/data/models/chapter_content.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extension_run_time.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/widgets/cache_network_image.dart';
import 'package:u_book/widgets/widgets.dart';

import '../cubit/read_book_cubit.dart';
// import 'package:zoom_widget/zoom_widget.dart';

class ChapterContent extends StatefulWidget {
  const ChapterContent(
      {super.key, required this.chapter, required this.pageController});
  final Chapter chapter;
  final PageController pageController;

  @override
  State<ChapterContent> createState() => _ChapterContentState();
}

class _ChapterContentState extends State<ChapterContent>
    with AutomaticKeepAliveClientMixin {
  bool _loadContent = false;

  List<ComicContent> list = [];
  late ScrollController _scrollController;
  late ValueNotifier<ContentPagination?> _contentPaginationValue;
  double? _heightScreen;
  late ReadBookCubit _readBookCubit;

  bool _autoScroll = false;
  late ExtensionRunTime _extensionRunTime;

  @override
  void initState() {
    _extensionRunTime = getIt<ExtensionsManager>().runTimePrimary!;

    if (mounted) {
      _onGet();
    }

    _contentPaginationValue = ValueNotifier(null);
    _scrollController = ScrollController();
    _scrollController.addListener(_handlerScrollListener);
    _readBookCubit = context.read<ReadBookCubit>();

    super.initState();
  }

  void _handlerScrollListener() {
    _calculateContentPagination();
  }

  void _calculateContentPagination() {
    try {
      final heightContentFull = _scrollController.position.maxScrollExtent;
      final heightCurrentContent = _scrollController.offset;
      _heightScreen ??= context.height;
      _contentPaginationValue.value = ContentPagination(
          sliderValue: (heightCurrentContent / heightContentFull) * 100,
          totalPage: heightContentFull ~/ _heightScreen! == 0
              ? 1
              : heightContentFull ~/ _heightScreen!,
          currentPage: heightCurrentContent ~/ _heightScreen! == 0
              ? 1
              : heightCurrentContent ~/ _heightScreen!);
    } catch (error) {}
  }

  void _onGet() async {
    setState(() {
      _loadContent = true;
    });
    final content = await _extensionRunTime.chapter(widget.chapter.url);
    if (content is List) {
      list = content.map((e) => ComicContent.fromMap(e)).toList();
    }
    setState(() {
      _loadContent = false;
    });
  }

  void _closeAutoScroll() {
    _scrollController.position.hold(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final textTheme = context.appTextTheme;
    final width = context.width;

    return MultiBlocListener(
      listeners: [
        BlocListener<ReadBookCubit, ReadBookState>(
          listenWhen: (previous, current) {
            if (previous.runtimeType != current.runtimeType) {
              return true;
            }
            if (previous is AutoScrollReadBook &&
                current is AutoScrollReadBook &&
                widget.chapter == _readBookCubit.currentChapter) {
              if (previous.timerScroll != current.timerScroll) {
                _handlerAutoScroll();
                return true;
              }
              if (previous.scrollStatus != current.scrollStatus) {
                return true;
              }
              return false;
            }
            return false;
          },
          listener: (context, state) {
            if (state is AutoScrollReadBook &&
                widget.chapter == _readBookCubit.currentChapter) {
              switch (state.scrollStatus) {
                case AutoScrollStatus.start:
                  _handlerAutoScroll();
                  break;
                case AutoScrollStatus.pause:
                case AutoScrollStatus.stop:
                  _closeAutoScroll();
                  break;
                default:
                  break;
              }
            } else if (_autoScroll) {
              _closeAutoScroll();
              _autoScroll = false;
            }
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            alignment: Alignment.bottomLeft,
            child: Text(
              widget.chapter.title,
              style: textTheme.bodySmall?.copyWith(fontSize: 12),
            ),
          ),
          Expanded(
            child: _loadContent
                ? const LoadingWidget()
                : SingleChildScrollView(
                    physics: _readBookCubit.getPhysicsScroll(),
                    controller: _scrollController,
                    child: BlocBuilder<ReadBookCubit, ReadBookState>(
                      builder: (context, state) {
                        final headers = {"Referer": _readBookCubit.book.host};
                        return switch (_readBookCubit.bookType) {
                          BookType.comic => Column(
                              children: list
                                  .map((e) => CacheNetWorkImage(
                                        e.url,
                                        fit: BoxFit.fitWidth,
                                        width: width,
                                        headers: headers,
                                        placeholder: Container(
                                            height: 200,
                                            alignment: Alignment.center,
                                            child: const SpinKitPulse(
                                              color: Colors.grey,
                                            )),
                                      ))
                                  .toList(),
                            ),
                          _ => const SizedBox()
                        };
                      },
                    ),
                  ),
          ),
          _buildFooterWidget()
        ],
      ),
    );
  }

  Widget _buildFooterWidget() {
    const textStyle = TextStyle(fontSize: 11);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(
            "${widget.chapter.index}/${_readBookCubit.book.totalChapter}",
            style: textStyle,
            textAlign: TextAlign.left,
          ),
          ValueListenableBuilder(
            valueListenable: _contentPaginationValue,
            builder: (context, value, child) {
              if (value == null) return const SizedBox();
              return Text(
                value.formatText,
                style: textStyle,
                textAlign: TextAlign.right,
              );
            },
          )
        ].expandedEqually().toList(),
      ),
    );
  }

  void _handlerAutoScroll() async {
    final state = _readBookCubit.state;
    if (state is! AutoScrollReadBook) return;
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _readBookCubit.onAutoScrollNexPage();
    }
    final height = context.height;
    final heightText =
        _scrollController.position.maxScrollExtent - _scrollController.offset;
    double timer = (heightText / height) * state.timerScroll;
    if (timer <= 0) timer = 0.5;
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(seconds: timer.toInt()),
        curve: Curves.linear);
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      _readBookCubit.onAutoScrollNexPage();
    }
    _autoScroll = true;
  }

  @override
  bool get wantKeepAlive => true;
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
