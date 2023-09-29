import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/constants/assets.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/pages/home/view/book_scaffold.dart';
import 'package:u_book/widgets/cache_network_image.dart';
import '../cubit/detail_book_cubit.dart';
import '../widgets/widgets.dart';

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({super.key});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  late DetailBookCubit _detailBookCubit;
  @override
  void initState() {
    _detailBookCubit = context.read<DetailBookCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coverUrl = _detailBookCubit.book.cover;
    final book = _detailBookCubit.book;
    return Scaffold(
        // appBar: AppBar(centerTitle: true, title: const Text("Detail book")),
        body: Column(
      children: [
        SizedBox(
          height: context.height * 0.3,
          // color: Colors.teal,
          child: Stack(
            children: [
              Positioned.fill(
                child: CacheNetWorkImage(coverUrl),
              ),
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13.0),
                    child: const SizedBox(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Gaps.wGap16,
                      Container(
                        width: 140,
                        color: Colors.red,
                        child: CacheNetWorkImage(coverUrl),
                      ),
                      Gaps.wGap12,
                      Expanded(
                          child: Container(
                        // color: Colors.teal,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(book.name),
                              ),
                              Text(book.author),
                              const Text("Đang ra")

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
        Expanded(
            flex: 2,
            child: Container(
                // color: Colors.white,
                ))
      ],
    ));
  }
}
