// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:u_book/app/constants/gaps.dart';
import 'package:u_book/app/extensions/extensions.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/pages/splash/view/extension/metadata.dart';
import 'package:u_book/pages/splash/view/extension/script.dart';
import 'package:u_book/pages/splash/view/runtime.dart';
import 'package:u_book/utils/directory_utils.dart';

import 'extension/extension_model.dart';

class TestUi extends StatefulWidget {
  const TestUi({super.key});

  @override
  State<TestUi> createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> {
  final RunTime _runTime = RunTime();

  List<ExtensionModel> exts = [];
  @override
  void initState() {
    _runTime.initRuntime();
    load();
    super.initState();
  }

  void load() async {
    exts = await loadLocalExtension();
    setState(() {});
  }

  String chapter = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    final url =
                        "${exts.first.metadata.source}${exts.first.metadata.tabsHome.first.url}";
                    final list = await _runTime.listBook(
                        url: url,
                        page: 0,
                        jsScript: DirectoryUtils.getJsScriptByPath(
                            exts.first.script.home!),
                        extType: ExtensionType.comic);
                    print(list.length);
                  } on RuntimeException catch (runtimeExp) {
                    print(runtimeExp.type);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("HOME")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final list = await _runTime.detail(
                        url:
                            "https://saytruyenmoi.com/truyen-tu-than-phieu-nguyet.html",
                        jsScript: DirectoryUtils.getJsScriptByPath(
                            exts.first.script.detail!),
                        extType: ExtensionType.comic);
                    print(list);
                  } on RuntimeException catch (runtimeExp) {
                    print(runtimeExp.type);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("DETAIL")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final list = await _runTime.getChapters(
                      url:
                          "https://saytruyenmoi.com/truyen-tu-than-phieu-nguyet.html",
                      jsScript: DirectoryUtils.getJsScriptByPath(
                          exts.first.script.chapters!),
                    );
                    print(list);
                  } on RuntimeException catch (runtimeExp) {
                    print(runtimeExp.type);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("Chapters")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final list = await _runTime.chapter(
                      url:
                          "https://saytruyenmoi.com/truyen-tu-than-phieu-nguyet/chuong-56",
                      jsScript: DirectoryUtils.getJsScriptByPath(
                          exts.first.script.chapter!),
                    );
                    print(list);
                  } on RuntimeException catch (runtimeExp) {
                    print(runtimeExp.type);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("Chapter")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final list = await _runTime.search(
                        url: "https://saytruyenmoi.com/search",
                        keyWord: "to",
                        page: 0,
                        jsScript: DirectoryUtils.getJsScriptByPath(
                            exts.first.script.search!),
                        extType: ExtensionType.comic);
                    print(list.length);
                  } on RuntimeException catch (runtimeExp) {
                    print(runtimeExp.type);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("SEARCH")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final res = await DioClient().get(
                        "https://github.com/lamphuchai-dev/book_project/raw/main/ext-book/say_truyen/extension.zip",
                        options: Options(responseType: ResponseType.bytes));
                    archiveZipFileExtension(res);
                  } on RuntimeException catch (runtimeExp) {
                    print(runtimeExp.type);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("Download Extension")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final string = DirectoryUtils.getJsScriptByPath(
                        "/data/user/0/com.example.u_book/app_flutter/extensions/say-truyen/src/home.js");
                    print(string);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("GET STRING")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    loadLocalExtension();
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("TEST")),
            Gaps.hGap16,
            ElevatedButton(
                onPressed: () async {
                  try {
                    final res = await DioClient().get(
                        "https://github.com/lamphuchai-dev/book_project/raw/main/ext-book/extensions.json");
                    final metadata = jsonDecode(res)
                        .map<Metadata>((map) => Metadata.fromMap(map))
                        .toList();
                    print(metadata);
                  } catch (error) {
                    print(error);
                  }
                },
                child: const Text("Load exts")),
          ])),
    );
  }

  Future<ExtensionModel?> archiveZipFileExtension(Uint8List bytes) async {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      final fileExt = archive.files
          .firstWhereOrNull((item) => item.name == "extension.json");
      if (fileExt != null) {
        final contentString = utf8.decode(fileExt.content as List<int>);
        ExtensionModel ext = ExtensionModel.fromJson(contentString);
        final path = await DirectoryUtils.getDirectoryExtensions;
        Script script = Script();
        final pathExt = "$path/${ext.metadata.slug}";
        for (final file in archive) {
          final filename = file.name;
          final pathFile = "$pathExt/$filename";
          if (file.isFile) {
            final data = file.content as List<int>;
            File(pathFile)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
            if (ext.script.home == filename) {
              script.home = pathFile;
            } else if (ext.script.detail == filename) {
              script.detail = pathFile;
            } else if (ext.script.chapters == filename) {
              script.chapters = pathFile;
            } else if (ext.script.chapter == filename) {
              script.chapter = pathFile;
            } else if (ext.script.search == filename) {
              script.search = pathFile;
            } else if (ext.script.genre == filename) {
              script.genre = pathFile;
            }
          } else {
            Directory(pathFile).create(recursive: true);
          }
        }
        ext = ext.copyWith(
            script: script,
            metadata: ext.metadata.copyWith(localPath: pathExt));
        File("$pathExt/$fileExt")
          ..createSync(recursive: true)
          ..writeAsBytesSync(utf8.encode(ext.toJson()));
        return ext;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return null;
  }

  Future<void> test(String url, String code) async {
    try {
      final list = await _runTime.listBook(
          url: url, page: 0, jsScript: code, extType: ExtensionType.comic);
      for (var item in list) {
        print(item.name);
      }
    } on RuntimeException catch (runtimeExp) {
      print(runtimeExp.type);
    } catch (error) {
      print(error);
    }
  }

  Future<List<ExtensionModel>> loadLocalExtension() async {
    final dir =
        Directory(await DirectoryUtils.getDirectoryExtensions).listSync();
    List<ExtensionModel> exts = [];
    for (var item in dir) {
      final extFile = File("${item.path}/extension.json");
      final ext = ExtensionModel.fromJson(extFile.readAsStringSync());
      exts.add(ext);
    }
    return exts;
  }

  String code() {
    String detail = '''
async function search(url,kw, page) {
  const res = await Extension.request(url, {
    queryParameters: {
      page: page,
      s: kw,
    },
  });
  const list = await Extension.querySelectorAll(res, "div.page-item-detail");
  const result = [];
  for (const item of list) {
    const html = item.content;
    var cover = await Extension.getAttributeText(html, "img", "data-src");

    if (cover == null) {
      cover = await Extension.getAttributeText(html, "img", "src");
    }
    if (cover && cover.startsWith("//")) {
      cover = "https:" + cover;
    }
    result.push({
      name: await Extension.querySelector(html, "div.post-title a").text,
      bookUrl: await Extension.getAttributeText(
        html,
        "div.post-title a",
        "href"
      ),
      description: await await Extension.querySelector(
        html,
        "div.chapter-item a"
      ).text,
      cover,
    });
  }
  return result;
}

''';
    return detail;
  }
}
