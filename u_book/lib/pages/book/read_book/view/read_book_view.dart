import 'package:flutter/material.dart';
import '../cubit/read_book_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'read_book_page.dart';

class ReadBookView extends StatelessWidget {
  const ReadBookView({super.key});
  static const String routeName = '/read_book_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReadBookCubit()..onInit(),
      child: const ReadBookPage(),
    );
  }
}
