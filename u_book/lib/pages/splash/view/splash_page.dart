import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/app/routes/routes_name.dart';
import 'package:u_book/widgets/widgets.dart';
import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashCubit _splashCubit;
  @override
  void initState() {
    _splashCubit = context.read<SplashCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listenWhen: (previous, current) =>
            previous.statusType != current.statusType,
        listener: (context, state) {
          if (state.statusType == StatusType.loaded) {
            Navigator.pushReplacementNamed(context, RoutesName.bottomNav);
          }
        },
        child: const LoadingWidget(),
      ),
    );
  }
}
