import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/book.dart';

import 'grid_controller.dart';
import 'item_book.dart';

class SliverGridWidget extends StatelessWidget {
  const SliverGridWidget({super.key, required this.controller});
  final GirdStateController controller;

  @override
  Widget build(BuildContext context) {
    ({int minItem, int maxItem, double heightItem, int crossAxisCount}) _get(
        int countItem) {
      const minWidth = 90;
      const maxWidth = 180;
      const heightFot = 40;

      final width = context.width - Dimens.horizontalPadding * 2;
      final minItem = width ~/ maxWidth;
      final maxItem = width ~/ minWidth;
      final heightItem = (width / countItem) * 1.45 + heightFot;
      return (
        minItem: minItem,
        maxItem: maxItem,
        heightItem: heightItem,
        crossAxisCount: countItem
      );
    }

    final tmp = _get(3);

    return CustomScrollView(
      slivers: [
        SliverAnimatedGrid(
            key: controller.girdKey,
            initialItemCount: controller.items.length,
            itemBuilder: (context, index, animation) {
              // return _item();

              // return SlideTransition(
              //     // alignment: Alignment.centerLeft,
              //     // offset: Offset(0, animation.value),
              //     // offset: Offset((1 - animation.value) * 10, 0),
              //     position: Tween<Offset>(
              //       begin: const Offset(-1.0, 0.0),
              //       end: Offset.zero,
              //     )
              //         .chain(CurveTween(curve: Curves.bounceIn))
              //         .animate(animation),
              //     child: _item());
              // print("index : $index , status : ${animation.status}");
              // return AnimatedBuilder(
              //   animation: animation,
              //   builder: (context, child) {
              //     // print(animation.value);
              //     return _item();
              //   },
              // );
              return ItemBook(
                book: Book.bookTest(),
                onTap: () {
                  // print("object");
                  Navigator.pushNamed(context, RoutesName.detailBook,
                      arguments: Book.bookTest());
                },
                onLongTap: () {},
              );
              // if (animation.status == AnimationStatus.completed) {
              //   return _item();
              // }
              // return TweenAnimationBuilder<double>(
              //   tween: Tween(begin: 1, end: 0),
              //   duration: Duration(milliseconds: 200),
              //   curve: Curves.elasticOut,
              //   child: _item(),
              //   builder: (context, value, child) {
              //     return Transform.translate(
              //       offset: Offset(0, (1 - animation.value) * 10),
              //       child: child,
              //     );
              //   },
              // );

              // return ScaleTransition(
              //   scale: CurvedAnimation(
              //     parent: animation,
              //     curve: const Interval(
              //       0.00,
              //       0.50,
              //       curve: Curves.linear,
              //     ),
              //   ),
              //   child: FadeTransition(
              //     opacity: CurvedAnimation(
              //       parent: animation,
              //       curve: Curves.linear,
              //     ),
              //     child: Container(
              //       decoration: const BoxDecoration(),
              //       child: Column(children: [
              //         Expanded(
              //             child: Container(
              //           color: Colors.teal,
              //         )),
              //         Gaps.hGap4,
              //         const SizedBox(
              //           height: 35,
              //           child: Text(
              //             "interface that is organized",
              //             style: TextStyle(fontSize: 15, height: 1),
              //             maxLines: 2,
              //           ),
              //         ),
              //         const Text(
              //           "A Grid is a user interface that is organized",
              //           style: TextStyle(fontSize: 11),
              //           maxLines: 1,
              //         )
              //       ]),
              //     ),
              //   ),
              // );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: tmp.crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisExtent: tmp.heightItem,
                mainAxisSpacing: 8))
      ],
    );
  }

  Widget _item() {
    return Container(
      height: 140,
      width: 140,
      color: Colors.teal,
    );
  }
}

class ItemGird extends StatefulWidget {
  const ItemGird({super.key});

  @override
  State<ItemGird> createState() => _ItemGirdState();
}

class _ItemGirdState extends State<ItemGird>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
          // alignment: Alignment.centerLeft,
          // offset: Offset(0, animation.value),
          offset: Offset(0, (1 - (_controller.value)) * 60),
          child: Container(
            height: 150,
            width: 140,
            color: Colors.red,
            // child: Text(animation.value.toString()),
          )),
    );
  }
}
