import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:u_book/di/components/service_locator.dart';
import 'package:u_book/pages/splash/view/extension/metadata.dart';
import 'package:u_book/pages/splash/view/extensions_manager.dart';

class ExtsWidget extends StatefulWidget {
  const ExtsWidget({super.key});

  @override
  State<ExtsWidget> createState() => _ExtsWidgetState();
}

class _ExtsWidgetState extends State<ExtsWidget> {
  final extManager = getIt<ExtensionManager>();
  List<Metadata> _list = [];
  @override
  void initState() {
    extManager.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final list = await extManager.getListExts();
                    setState(() {
                      _list = list;
                    });
                  },
                  child: const Text("LOAD")),
              Expanded(
                  child: Column(
                children: _list
                    .map((e) => ListTile(
                          title: Text(e.name),
                          onTap: () {
                            extManager.installExtensionByUrl(e.path);
                          },
                        ))
                    .toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
