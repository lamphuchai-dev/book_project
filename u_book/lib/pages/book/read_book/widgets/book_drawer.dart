import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/pages/book/read_book/cubit/read_book_cubit.dart';
import 'package:u_book/widgets/cache_network_image.dart';
import 'package:u_book/widgets/widgets.dart';

class BookDrawer extends StatefulWidget {
  const BookDrawer({super.key});

  @override
  State<BookDrawer> createState() => _BookDrawerState();
}

class _BookDrawerState extends State<BookDrawer> {
  final backgroundColor = Colors.grey;
  late ReadBookCubit _readBookCubit;
  late Book _book;

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     systemNavigationBarColor: backgroundColor,
    //   ),
    // );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    _readBookCubit = context.read<ReadBookCubit>();
    _book = _readBookCubit.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.appTextTheme;
    final colorScheme = context.colorScheme;
    return Drawer(
      width: context.width * 0.85,
      // backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
          child: Column(children: [
        _headerDrawer(),
        Expanded(
          child: ListChaptersWidget(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            indexSelect: _readBookCubit.indexPageChapter,
            chapters: _book.chapters,
            onTapChapter: (chapter) {
              _readBookCubit.onToPageByChapter(chapter);
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ])),
    );
  }

  Widget _headerDrawer() {
    return Container(
      height: 100,
      // color: Colors.red,
      child: CacheNetWorkImage(
        _book.bookUrl,
        key: ValueKey(_book.name),
      ),
    );
  }
}
