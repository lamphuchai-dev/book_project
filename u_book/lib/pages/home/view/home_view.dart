import 'package:flutter/material.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/pages/splash/view/extensions_manager.dart';
import 'package:u_book/services/extensions_manager.dart';
import 'package:u_book/services/storage_service.dart';
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
          extensionsManager: getIt<ExtensionsManager>(),
          storageService: getIt<StorageService>(),
          extensionManager: getIt<ExtensionManager>())
        ..onInit(),
      child: const HomePage(),
    );
  }
}
