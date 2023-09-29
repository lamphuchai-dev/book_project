import 'package:flutter/material.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/pages/home/view/grid_controller.dart';

import 'sliver_grid_widget.dart';
import 'tmp.dart';

class BuildGird extends StatefulWidget {
  const BuildGird({super.key});

  @override
  State<BuildGird> createState() => _BuildGirdState();
}

class _BuildGirdState extends State<BuildGird> {
  final GirdStateController _controller = GirdStateController<int>(items: [
    1,
    2,
    3,
  ]);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SliverGridWidget(
          controller: _controller,
        )),
        // SizedBox(
        //   height: 400,
        //   width: double.infinity,
        //   child: const PageViewDemo(),
        // ),
        Gaps.hGap20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {
                  _controller.insertItem(3);
                },
                child: const Text("TEST")),
            ElevatedButton(
                onPressed: () {
                  _controller.deleteItemByIndex(0);
                },
                child: const Text("DELETE")),
            ElevatedButton(onPressed: () {}, child: const Text("TEST"))
          ],
        )
      ],
    );
  }
}
