import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/extensions/context_extension.dart';
import 'package:u_book/pages/book/read_book/widgets/book_drawer.dart';
import 'package:u_book/utils/system_utils.dart';
import '../cubit/read_book_cubit.dart';
import '../widgets/widgets.dart';

class ReadBookPage extends StatefulWidget {
  const ReadBookPage({super.key});

  @override
  State<ReadBookPage> createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage>
    with SingleTickerProviderStateMixin {
  late ReadBookCubit _readBookCubit;
  late PageController _pageController;
  late AnimationController _animationController;
  late ColorScheme colorScheme;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _readBookCubit = context.read<ReadBookCubit>();
    _pageController = _readBookCubit.pageController;
    _readBookCubit.setMenuAnimationController(_animationController);
    SystemUtils.setEnabledSystemUIModeReadBookPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chapters = _readBookCubit.book.chapters;
    colorScheme = context.colorScheme;
    return Scaffold(
      // appBar: AppBar(centerTitle: true, title: const Text("Read book")),
      drawer: const BookDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _readBookCubit.onTapScreen,
              onPanDown: (_) => _readBookCubit.onTouchScreen(),
              child: BlocBuilder<ReadBookCubit, ReadBookState>(
                buildWhen: (previous, current) =>
                    previous.chapters != current.chapters ||
                    previous.runtimeType != current.runtimeType,
                builder: (context, state) {
                  return PageView.builder(
                    allowImplicitScrolling: true,
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: chapters.length,
                    onPageChanged: _readBookCubit.onPageChanged,
                    physics: _readBookCubit.getPhysicsScroll(),
                    itemBuilder: (context, index) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification is! OverscrollNotification) {
                            return false;
                          }
                          if (_pageController.page == 0.0 &&
                              notification.overscroll < 0) {
                            return false;
                          }
                          _pageController.jumpTo(_pageController.offset +
                              notification.overscroll * 1.2);
                          return false;
                        },
                        child: ChapterContent(
                          chapter: chapters[index],
                          pageController: _pageController,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          BlocBuilder<ReadBookCubit, ReadBookState>(
            buildWhen: (previous, current) =>
                previous.runtimeType != current.runtimeType,
            builder: (context, state) {
              Menu menu = Menu.base;
              if (state is AutoScrollReadBook) {
                menu = Menu.autoScroll;
              }
              // else if (state is ReadBookMedia) {
              //   menu = Menu.media;
              // }
              return MenuSliderAnimation(
                  menu: menu,
                  bottomMenu: const BottomBaseMenuWidget(),
                  topMenu: TopBaseMenuWidget(
                    book: _readBookCubit.book,
                  ),
                  autoScrollMenu: const AutoScrollMenuWidget(),
                  mediaMenu: const SizedBox(),
                  controller: _animationController);
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemUtils.setSystemNavigationBarColor(colorScheme.background);
    super.dispose();
  }
}
