import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/read_book_cubit.dart';
import '../widgets/widgets.dart';

class ReadBookPage extends StatefulWidget {
  const ReadBookPage({super.key});

  @override
  State<ReadBookPage> createState() => _ReadBookPageState();
}

class _ReadBookPageState extends State<ReadBookPage> {
  late ReadBookCubit _readBookCubit;
  @override
  void initState() {
    _readBookCubit = context.read<ReadBookCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Read book")),
      body: SizedBox(),
    );
  }
}
