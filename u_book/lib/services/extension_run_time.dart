// ignore_for_file: unused_element, depend_on_referenced_packages

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:u_book/app/extensions/log_extension.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/extension.dart';
import 'package:u_book/utils/logger.dart';

import 'main_code.dart';

class ExtensionRunTime {
  late Extension extension;
  late JavascriptRuntime runtime;

  final _logger = Logger("ExtensionRunTime");
  final _dioClient = DioClient();

  Future<bool> initRuntime(Extension ext) async {
    extension = ext;
    runtime = getJavascriptRuntime();

    runtime.onMessage('request', (dynamic args) async {
      _logger.log("request args ::: $args");

      final dataResponse = await _dioClient.request<String>(
        args[0],
        data: args[1]['data'],
        queryParameters: args[1]['queryParameters'] ?? {},
        options: Options(
          headers: args[1]['headers'] ?? {},
          method: args[1]['method'] ?? 'get',
        ),
      );
      return dataResponse;
    });

    runtime.onMessage('log', (dynamic args) {
      _logger.log(args, name: "LOG");
    });

    runtime.onMessage('querySelector', (dynamic args) {
      final content = args[0];
      final selector = args[1];
      final fun = args[2];
      final doc = parse(content).querySelector(selector);

      switch (fun) {
        case 'text':
          return doc?.text ?? '';
        case 'outerHTML':
          return doc?.outerHtml ?? '';
        case 'innerHTML':
          return doc?.innerHtml ?? '';
        default:
          return doc?.outerHtml ?? '';
      }
    });

    runtime.onMessage('querySelectorAll', (dynamic args) async {
      final content = args[0];
      final selector = args[1];
      final doc = parse(content).querySelectorAll(selector);
      final elements = jsonEncode(doc.map((e) {
        return e.outerHtml;
      }).toList());
      return elements;
    });

    runtime.onMessage('getElementById', (dynamic args) async {
      final content = args[0];
      final id = args[1];
      final fun = args[2];

      final doc = parse(content).getElementById(id);
      switch (fun) {
        case 'text':
          return doc?.text ?? '';
        case 'outerHTML':
          return doc?.outerHtml ?? '';
        case 'innerHTML':
          return doc?.innerHtml ?? '';
        default:
          return doc?.outerHtml ?? '';
      }
    });

    runtime.onMessage('queryXPath', (args) {
      final content = args[0];
      final selector = args[1];
      final fun = args[2];

      final xpath = HtmlXPath.html(content);
      final result = xpath.queryXPath(selector);

      switch (fun) {
        case 'attr':
          return result.attr ?? '';
        case 'attrs':
          return jsonEncode(result.attrs);
        case 'text':
          return result.node?.text;
        case 'allHTML':
          return result.nodes
              .map((e) => (e.node as Element).outerHtml)
              .toList();
        case 'outerHTML':
          return (result.node?.node as Element).outerHtml;
        default:
          return result.node?.text;
      }
    });

    runtime.onMessage('removeSelector', (dynamic args) {
      final content = args[0];
      final selector = args[1];
      final doc = parse(content);
      doc.querySelectorAll(selector).forEach((element) {
        element.remove();
      });
      return doc.outerHtml;
    });

    runtime.onMessage('getAttributeText', (args) {
      final content = args[0];
      final selector = args[1];
      final attr = args[2];
      final doc = parse(content).querySelector(selector);
      return doc?.attributes[attr];
    });
    return await _installExtension();
  }

  Future<bool> _installExtension() async {
    runtime.evaluate(mainCode);
    final ext = extension.jsScript!.replaceAll(
        RegExp(r'export default class.*'), 'class Ext extends Extension {');

    // final ext = sayTruyen.replaceAll(
    //     RegExp(r'export default class.*'), 'class Ext extends Extension {');
    JsEvalResult jsResult = await runtime.evaluateAsync('''
    $ext
    var extension = new Ext("${extension.source}","${extension.name}");
        extension.load().then(()=>{
        return true;
      });
    ''');
    final value = await runtime.handlePromise(jsResult);
    return value.stringResult == "true";
  }

  Future<String> getExtByUrl(String url) async {
    final res = await _dioClient.get(url);

    return res;
  }

  Future<T> _runExtension<T>(Future<T> Function() fun) async {
    try {
      return await fun();
    } catch (e) {
      // ExtensionUtils.addLog(
      //   extension,
      //   ExtensionLogLevel.error,
      //   e.toString(),
      // );
      _logger.error(e, name: "_runExtension");
      rethrow;
    }
  }

  Future<List<Book>> getListBook({required String url, int? page}) async {
    return _runExtension(() async {
      final jsResult = await runtime.handlePromise(await runtime
          .evaluateAsync('stringify(()=>extension.itemHome("$url",$page))'));
      return jsResult.toJson
          .map<Book>((map) => Book.fromExtensionType(extension.type, map))
          .toList();
    });
  }

  Future<Book> detail(String url) async {
    return await _runExtension(() async {
      final jsResult = await runtime.handlePromise(await runtime
          .evaluateAsync('stringify(()=>extension.detail("$url"))'));

      final mapResult = jsResult.toJson;
      return Book.fromExtensionType(extension.type, mapResult);
    });
  }

  Future<List<Chapter>> getChapters(String url) async {
    return _runExtension(() async {
      final jsResult = await runtime.handlePromise(await runtime
          .evaluateAsync('stringify(()=>extension.chapters("$url"))'));
      List<Chapter> chapters = (jsResult.toJson
          .map<Chapter>((map) => Chapter.fromMap(map))
          .toList());
      chapters.sort((a, b) => a.index.compareTo(b.index));
      return chapters;
    });
  }

  Future<List<String>> chapter(String url) async {
    return _runExtension(() async {
      final jsResult = await runtime.handlePromise(await runtime
          .evaluateAsync('stringify(()=>extension.chapter("$url"))'));

      return List<String>.from(jsResult.toJson);
    });
  }

  Future<List<Book>> search(String keyWord, int page) async =>
      _runExtension(() async {
        final jsResult = await runtime.handlePromise(
            await runtime.evaluateAsync(
                'stringify(()=>extension.search("$keyWord",$page))'));
        return jsResult.toJson
            .map<Book>((map) => Book.fromExtensionType(extension.type, map))
            .toList();
      });
}

extension Json on JsEvalResult {
  dynamic get toJson {
    final json = jsonDecode(stringResult);
    if (json.runtimeType.toString() == "String") {
      return jsonDecode(json);
    }
    return json;
  }
}
