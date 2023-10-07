import 'package:flutter/material.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extensions_manager.dart';
import '../cubit/read_book_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'read_book_page.dart';

class ReadBookView extends StatelessWidget {
  const ReadBookView({super.key, required this.book, required this.chapter});
  static const String routeName = '/read_book_view';
  final Book book;
  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadBookCubit(
          book: book,
          chapter: chapter,
          extensionRunTime: getIt<ExtensionsManager>().runTimePrimary!)
        ..onInit(),
      child: const ReadBookPage(),
    );
  }
}
