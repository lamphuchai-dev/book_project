// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extension_runtime.dart';
import 'package:u_book/services/extensions_manager.dart';

import '../cubit/chapters_cubit.dart';
import 'chapters_page.dart';

class ChaptersView extends StatelessWidget {
  const ChaptersView({super.key, required this.args});
  static const String routeName = '/chapters_view';
  final ChaptersBookArgs args;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChaptersCubit(
          book: args.book, extensionRunTime: args.extensionRunTime)
        ..onInit(),
      child: const ChaptersPage(),
    );
  }
}

class ChaptersBookArgs {
  final Book book;
  final ExtensionRunTime extensionRunTime;
  ChaptersBookArgs({
    required this.book,
    required this.extensionRunTime,
  });
}
