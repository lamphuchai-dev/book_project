import 'package:book/core/extension_runtime.dart';
import 'package:book/di/service_locator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ExtensionRuntime _runtime = getIt<ExtensionRuntime>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TEST"),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(children: [
          // ElevatedButton(
          //     onPressed: () {
          //       _runtime.fetch();
          //     },
          //     child: const Text("TEST")),
          // ElevatedButton(
          //     onPressed: () {
          //       _runtime.call();
          //     },
          //     child: const Text("CALL")),
          ElevatedButton(
              onPressed: () {
                _runtime.home();
              },
              child: const Text("Tabs home")),
          ElevatedButton(
              onPressed: () {
                _runtime.home();
              },
              child: const Text("HOME")),
          ElevatedButton(
              onPressed: () {
                _runtime.detail();
              },
              child: const Text("Detail")),
          ElevatedButton(
              onPressed: () {
                _runtime.chapter();
              },
              child: const Text("Chapter")),
          ElevatedButton(
              onPressed: () {
                _runtime.search();
              },
              child: const Text("Search")),
          // Container(
          //   width: 100,
          //   height: 100,
          //   child: Image.network(
          //     "https://cdnnvd.com/nettruyen/do-de-cua-ta-deu-la-dai-phan-phai/133/49.jpg",
          //     headers: {"Referer": "https://nettruyenco.vn"},
          //   ),
          // )
        ]),
      ),
    );
  }
}
