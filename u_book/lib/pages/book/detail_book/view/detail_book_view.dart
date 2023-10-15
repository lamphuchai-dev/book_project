// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/database_service.dart';
import 'package:u_book/services/extensions_service.dart';

import '../cubit/detail_book_cubit.dart';

import 'detail_book_page.dart';

class DetailBookView extends StatelessWidget {
  const DetailBookView({super.key, required this.args});
  final DetailBookArgs args;
  static const String routeName = '/detail_book_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBookCubit(
          book: args.book,
          extension: args.extensionModel,
          extensionManager: getIt<ExtensionsService>(),
          databaseService: getIt<DatabaseService>())
        ..onInit(),
      child: const DetailBookPage(),
    );
  }
}

class DetailBookArgs {
  final Book book;
  final Extension extensionModel;
  DetailBookArgs({
    required this.book,
    required this.extensionModel,
  });
}
