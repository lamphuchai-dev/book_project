import 'package:flutter/material.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/services/extension_service.dart';
import '../cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static const String routeName = '/home_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
          extension: Extension.fromMap(sayTruyenMap),
          extensionService: getIt<ExtensionService>())
        ..onInit(),
      child: const HomePage(),
    );
  }
}
