import 'package:flutter/material.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extension_service.dart';
import '../cubit/detail_book_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'detail_book_page.dart';

class DetailBookView extends StatelessWidget {
  const DetailBookView({super.key, required this.book});
  final Book book;
  static const String routeName = '/detail_book_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBookCubit(
          book: book, extensionService: getIt<ExtensionService>())
        ..onInit(),
      child: const DetailBookPage(),
    );
  }
}
