import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/constants/constants.dart';

import 'app.dart';
import 'app/bloc/debug/bloc_observer.dart';
import 'di/components/service_locator.dart';
import 'utils/system_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemUtils.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await setupLocator();

  Bloc.observer = const AppBlocObserver();

  runApp(
    EasyLocalization(
        supportedLocales: Constants.supportedLocales,
        path: 'assets/translations',
        fallbackLocale: Constants.defaultLocal,
        child: const App()),
  );
}
