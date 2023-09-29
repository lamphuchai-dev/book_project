import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/routes/routes.dart';

import 'app/bloc/global_cubit/global_cubit.dart';
import 'app/config/flavor_config.dart';
import 'app/theme/themes.dart';
import 'data/sharedpref/shared_preference_helper.dart';
import 'di/components/service_locator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GlobalCubit(sharedPreferenceHelper: getIt<SharedPreferenceHelper>())
            ..onInit(),
      child: BlocBuilder<GlobalCubit, GlobalState>(
        buildWhen: (previous, current) {
          if (previous.themeMode != current.themeMode) {
            return true;
          } else {
            return false;
          }
        },
        builder: (context, state) {
          return MaterialApp(
            title: FlavorConfig.instance?.name ?? "",
            themeMode: state.themeMode,
            theme: Themes.light,
            darkTheme: Themes.dark,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Routes.onGenerateRoute,
            initialRoute: Routes.initialRoute,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            // scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          );
        },
      ),
    );
  }
}
