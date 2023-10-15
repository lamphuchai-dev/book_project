import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/book.dart';
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
    // final textTheme = context.appTextTheme;
    // final colorScheme = context.colorScheme;
    return Drawer(
      width: context.width * 0.85,
      // backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(),
      child: Column(children: [
        _headerDrawer(),
        Expanded(
          child: ListChaptersWidget(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            indexSelect: _readBookCubit.indexPageChapter,
            chapters: _readBookCubit.chapters,
            onTapChapter: (chapter) {
              _readBookCubit.onToPageByChapter(chapter);
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ]),
    );
  }

  Widget _headerDrawer() {
    return SizedBox(
      height: context.height * 0.22,
      // color: Colors.red,
      // child: CacheNetWorkImage(
      //   _book.cover,
      //   key: ValueKey(_book.name),
      // ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
              child: BlurredBackdropImage(
            url: _book.cover,
          )),
          Positioned(
              top: kToolbarHeight,
              left: 16,
              bottom: 10,
              right: 0,
              child: Row(
                children: [
                  CacheNetWorkImage(_book.cover),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(_book.name),
                        ),
                        Expanded(child: Text(_book.author))
                      ],
                    ),
                  ))
                ],
              )),
        ],
      ),
    );
  }
}
