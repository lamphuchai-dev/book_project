import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/bloc/global_cubit/global_cubit.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';
import '../cubit/home_cubit.dart';
import '../widgets/widgets.dart';
import 'book_scaffold.dart';
import 'buid_gird.dart';
import 'list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeCubit _homeCubit;
  final _dioClient = DioClient();
  final _logger = Logger("_HomePageState");
  final pi = "http://192.168.1.9:3000/auth/sign-up";
  @override
  void initState() {
    _homeCubit = context.read<HomeCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BookScaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Home")),
        body: const BuildGird());
  }
}
