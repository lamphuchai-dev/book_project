import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/install_extension_cubit.dart';
import '../widgets/widgets.dart';

class InstallExtensionPage extends StatefulWidget {
  const InstallExtensionPage({super.key});

  @override
  State<InstallExtensionPage> createState() => _InstallExtensionPageState();
}

class _InstallExtensionPageState extends State<InstallExtensionPage> {
  late InstallExtensionCubit _installExtensionCubit;
  @override
  void initState() {
    _installExtensionCubit = context.read<InstallExtensionCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Install extension")),
      body: SizedBox(),
    );
  }
}
