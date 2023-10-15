import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/models.dart';
import 'package:u_book/pages/book/genre_book/genre_book.dart';
import 'package:u_book/widgets/widgets.dart';

class BookDetail extends StatelessWidget {
  const BookDetail({super.key, required this.book, required this.extension});
  final Book book;
  final Extension extension;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Gaps.hGap8, _genreBook(context), _description()],
      ),
    );
  }

  Widget _genreBook(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Thể loại"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: book.genres
                .map((e) => GenreCard(
                    genre: e,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.genreBook,
                          arguments: GenreBookArg(
                              genre: e, extension: extension));
                    }))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [const Text("Giới thiệu"), Text(book.description)],
    );
  }
}
