import 'dart:io';

import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/extensions.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  int _count = 2;

  GlobalKey<SliverAnimatedGridState> _listKey = GlobalKey();

  ({int minItem, int maxItem, double heightItem}) _get(int countItem) {
    const minWidth = 90;
    const maxWidth = 180;

    final width = context.width - Dimens.horizontalPadding * 2;
    final minItem = width ~/ maxWidth;
    final maxItem = width ~/ minWidth;
    final heightItem = (width / countItem) * 2;
    return (minItem: minItem, maxItem: maxItem, heightItem: heightItem);
  }

  @override
  Widget build(BuildContext context) {
    final tmp = _get(_count);

    return CustomScrollView(
      slivers: [
        // SliverGrid.builder(
        //   itemCount: 3,
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: _count,
        //       crossAxisSpacing: 8,
        //       mainAxisExtent: tmp.heightItem,
        //       mainAxisSpacing: 8),
        //   itemBuilder: (context, index) {
        //     return Container(
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
        //     );
        //   },
        // ),
        SliverToBoxAdapter(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    if (_count < tmp.maxItem) {
                      setState(() {
                        _count++;
                      });
                    }
                  },
                  child: const Text("+")),
              ElevatedButton(
                  onPressed: () {
                    // if (_count > tmp.minItem) {
                    //   setState(() {
                    //     _count--;
                    //   });
                    // }
                    _listKey.currentState?.insertItem(1);
                  },
                  child: const Text("-"))
            ],
          ),
        ),
        SliverAnimatedGrid(
            key: _listKey,
            initialItemCount: 1,
            itemBuilder: (context, index, animation) => Container(
                  decoration: const BoxDecoration(),
                  child: Column(children: [
                    Expanded(
                        child: Container(
                      color: Colors.teal,
                    )),
                    Gaps.hGap4,
                    const SizedBox(
                      height: 35,
                      child: Text(
                        "interface that is organized",
                        style: TextStyle(fontSize: 15, height: 1),
                        maxLines: 2,
                      ),
                    ),
                    const Text(
                      "A Grid is a user interface that is organized",
                      style: TextStyle(fontSize: 11),
                      maxLines: 1,
                    )
                  ]),
                ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _count,
                crossAxisSpacing: 8,
                mainAxisExtent: tmp.heightItem,
                mainAxisSpacing: 8))
      ],
    );
  }
}
