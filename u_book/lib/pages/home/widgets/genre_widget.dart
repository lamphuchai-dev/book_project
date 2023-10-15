import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/data/models/genre.dart';
import 'package:u_book/pages/book/genre_book/genre_book.dart';
import 'package:u_book/widgets/widgets.dart';

typedef OnFetch = Future<List<Genre>> Function();

class GenreWidget extends StatefulWidget {
  const GenreWidget(
      {super.key, required this.onFetch, required this.extension});
  final OnFetch onFetch;
  final Extension extension;

  @override
  State<GenreWidget> createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  bool load = false;
  List<Genre> _listMap = [];
  void _onFetch() async {
    setState(() {
      load = true;
    });
    final tmp = await widget.onFetch.call();
    setState(() {
      _listMap = tmp;
    });

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    _onFetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (load) {
      return const LoadingWidget();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Wrap(
        children: _listMap
            .map((genre) => GenreCard(
                  genre: genre,
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.genreBook,
                        arguments: GenreBookArg(
                            genre: genre, extension: widget.extension));
                  },
                ))
            .toList(),
      ),
    );
  }
}
