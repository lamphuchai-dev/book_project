import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_view/json_view.dart';

import '../cubit/home_cubit.dart';

class LogWidget extends StatelessWidget {
  const LogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.log != current.log,
      builder: (context, state) {
        if (state.log == "") return const SizedBox();
        try {
          // final json = jsonDecode(state.log);
          // if (json.runtimeType.toString() == "String") {
          //   return SingleChildScrollView(
          //     child: Text(json),
          //   );
          // }
          return JsonConfig(
            data: JsonConfigData(
              animation: true,
              animationDuration: const Duration(milliseconds: 300),
              animationCurve: Curves.ease,
              itemPadding: const EdgeInsets.only(left: 8),
              color: const JsonColorScheme(
                  // stringColor: Colors.grey,
                  ),
              style: const JsonStyleScheme(
                arrow: Icon(Icons.arrow_right),
              ),
            ),
            child: JsonView(json: state.log),
          );
        } catch (error) {
          return SingleChildScrollView(
            child: Text(state.log.toString()),
          );
        }
      },
    );
  }
}
