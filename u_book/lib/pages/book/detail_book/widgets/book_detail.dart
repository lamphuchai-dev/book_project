import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/data/models/book.dart';

class BookDetail extends StatelessWidget {
  const BookDetail({super.key, required this.book});
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Gaps.hGap8, Text(book.description)],
      ),
    );
  }
}
