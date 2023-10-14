import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:dio_client/index.dart';
import 'package:equatable/equatable.dart';
import 'package:extensions_client/js_runtime.dart';
import 'package:extensions_client/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState(result: "", log: ""));
  final _logger = Logger("HomeCubit");

  final _jsRuntime = JsRuntime();
  final TextEditingController urlTextEditingController =
      TextEditingController();
  final TextEditingController jsCodeTextEditingController =
      TextEditingController();

  void onInit() async {
    final init = await _jsRuntime.initRuntime();
    _logger.log("jsRuntime init : $init ");
    _jsRuntime.log.listen((event) {
      emit(state.copyWith(log: event));
    });
  }

  void onGo(BuildContext context) async {
    try {
      emit(state.copyWith(result: "", log: ""));

      final result = await _jsRuntime.runJsCode(
          jsScript: jsCodeTextEditingController.text);

      emit(state.copyWith(result: jsonEncode(result)));
    } on RuntimeException catch (error) {
      Flushbar(
        title: "ERROR ${error.type}",
        titleColor: Colors.red,
        message: error.error,
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 3),
      ).show(context);
    } catch (error) {
      Flushbar(
        title: "ERROR",
        titleColor: Colors.red,
        message: error.toString(),
        animationDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }
}
