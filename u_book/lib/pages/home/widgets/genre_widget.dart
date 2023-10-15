import 'package:flutter/material.dart';
import 'package:u_book/app/constants/dimens.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/widgets/widgets.dart';

typedef OnFetch = Future<List<Map<String, dynamic>>> Function();

class GenreWidget extends StatefulWidget {
  const GenreWidget({super.key, required this.onFetch});
  final OnFetch onFetch;

  @override
  State<GenreWidget> createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  bool load = false;
  List<Map<String, dynamic>> _listMap = [];
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
    final colorScheme = context.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.horizontalPadding),
      child: Wrap(
        children: _listMap.map((e) => _genreCard(e, colorScheme)).toList(),
      ),
    );
  }

  Widget _genreCard(Map<String, dynamic> map, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: colorScheme.surface, borderRadius: BorderRadius.circular(4)),
      child: Text(map["title"] ?? ""),
    );
  }
}
