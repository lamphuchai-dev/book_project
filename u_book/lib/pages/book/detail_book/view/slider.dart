import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/widgets/cache_network_image.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final collapsedBarHeight = kToolbarHeight;
  final expandedBarHeight = 250.0;
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isCollapsed = ValueNotifier(false);
  final ValueNotifier<double> _offset = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    final coverUrl = Book.bookTest().bookUrl;
    return Material(
      child: NotificationListener(
        onNotification: (notification) {
          _offset.value = _scrollController.offset / (expandedBarHeight);
          if (_scrollController.hasClients &&
              _scrollController.offset >
                  (expandedBarHeight - collapsedBarHeight) &&
              !isCollapsed.value) {
            isCollapsed.value = true;
          } else if (!(_scrollController.hasClients &&
                  _scrollController.offset >
                      (expandedBarHeight - collapsedBarHeight)) &&
              isCollapsed.value) {
            isCollapsed.value = false;
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: expandedBarHeight,
              collapsedHeight: collapsedBarHeight,
              centerTitle: false,
              pinned: true,
              title: ValueListenableBuilder(
                valueListenable: _offset,
                builder: (context, value, child) => Opacity(
                  // duration: const Duration(milliseconds: 200),
                  opacity: value.clamp(0.0, 1.0),
                  child: const Text("Lam Phuc Hai"),
                ),
              ),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              ],
              elevation: 0,
              // backgroundColor:
              //     isCollapsed.value ? Colors.black : Colors.transparent,
              leading: const BackButton(
                color: Colors.white,
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    const Positioned.fill(
                      child: CacheNetWorkImage(
                          "https://images.unsplash.com/photo-1695575161610-7aeb03933996?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=800&q=60"),
                    ),
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9.0),
                          child: const SizedBox(),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 0,
                      top: kToolbarHeight + 16,
                      child: SizedBox(
                        // color: Colors.teal,
                        height: 180,
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Gaps.wGap16,
                            Container(
                              width: 140,
                              height: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              clipBehavior: Clip.hardEdge,
                              child: const CacheNetWorkImage(
                                  "https://images.unsplash.com/photo-1695575161610-7aeb03933996?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw0fHx8ZW58MHx8fHx8&auto=format&fit=crop&w=800&q=60"),
                            ),
                            Gaps.wGap12,
                            Expanded(
                                child: Container(
                              // color: Colors.teal,
                              child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       vertical: 12),
                                    //   child: Text(book.name),
                                    // ),
                                    // Text(book.author),
                                    // const Text("Đang ra")

                                    // Expanded(flex: , child: Text(book.name))
                                  ]),
                            )),
                            Gaps.wGap16,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 250 - 56),
                child: Material(
                  elevation: 7,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      15,
                    ),
                    topRight: Radius.circular(
                      15,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(children: [
                      listCardWidget(
                          text1: 'Full Name:', text2: 'George John Carter'),
                      listCardWidget(
                          text1: 'Father\'s Name:', text2: 'John Carter'),
                      listCardWidget(text1: 'Gender:', text2: 'Male'),
                      listCardWidget(
                          text1: 'Full Name:', text2: 'George John Carter'),
                      listCardWidget(
                          text1: 'Father\'s Name:', text2: 'John Carter'),
                      listCardWidget(text1: 'Gender:', text2: 'Male'),
                      listCardWidget(
                          text1: 'Full Name:', text2: 'George John Carter'),
                      listCardWidget(
                          text1: 'Father\'s Name:', text2: 'John Carter'),
                      listCardWidget(text1: 'Gender:', text2: 'Male'),
                      listCardWidget(
                          text1: 'Full Name:', text2: 'George John Carter'),
                      listCardWidget(
                          text1: 'Father\'s Name:', text2: 'John Carter'),
                      listCardWidget(text1: 'Gender:', text2: 'Male'),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listCardWidget({required String text1, required text2}) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                fit: FlexFit.tight,
                child: Text(
                  text1,
                  style: const TextStyle(fontSize: 18),
                )),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Text(
                text2,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  MySliverAppBar({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff8360c3),
                Color(0xff2ebf91),
              ],
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: Opacity(
        //     opacity: shrinkOffset / expandedHeight,
        //     child: SafeArea(
        //       child: const Text(
        //         'My Profile',
        //         style: TextStyle(
        //           color: Colors.black,
        //           fontWeight: FontWeight.w700,
        //           fontSize: 23,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        AppBar(
          title: const Text("ff"),
        ),
        Positioned(
          top: expandedHeight / 4 - shrinkOffset,
          left: MediaQuery.of(context).size.width / 4,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Column(
              children: [
                const Text(
                  'Check out my Profile',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: SizedBox(
                    height: expandedHeight,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Container(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
