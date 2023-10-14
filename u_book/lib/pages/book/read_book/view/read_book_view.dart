// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extensions_service.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extensions_service.dart';

import '../cubit/read_book_cubit.dart';
import 'read_book_page.dart';

class ReadBookView extends StatelessWidget {
  const ReadBookView(
      {super.key,
      // required this.book,
      // required this.chapter,
      // required this.chapters
      required this.readBookArgs});
  static const String routeName = '/read_book_view';
  // final Book book;
  // final Chapter chapter;
  // final List<Chapter> chapters;
  final ReadBookArgs readBookArgs;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadBookCubit(
          // book: readBookArgs.book,
          // chapter: readBookArgs.chapter,
          // chapters: readBookArgs.chapters,
          // extensionJsRuntime: getIt<ExtensionsManager>().runTimePrimary!
          jsRuntime: getIt<ExtensionsService>().jsRuntime,
          extensionManager: getIt<ExtensionsService>(),
          readBookArgs: readBookArgs,
          databaseService: getIt<DatabaseService>())
        ..onInit(),
      child: const ReadBookPage(),
    );
  }
}

class ReadBookArgs {
  final Book book;
  final int? readChapter;
  final List<Chapter> chapters;
  final bool fromBookmarks;
  final bool loadChapters;
  ReadBookArgs(
      {required this.book,
      this.readChapter,
      required this.chapters,
      required this.fromBookmarks,
      required this.loadChapters});
}
