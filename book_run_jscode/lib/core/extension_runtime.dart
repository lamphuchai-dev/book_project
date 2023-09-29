// ignore_for_file: unused_element

import 'dart:convert';

import 'package:book/core/logger.dart';
import 'package:book/models/book.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

import '../models/extension.dart';
import 'main_code.dart';

class ExtensionRuntime {
  late Extension extension;
  late JavascriptRuntime runtime;
  late PersistCookieJar _cookieJar;
  final _dio = Dio();
  final String _cuurentRequestUrl = '';
  final _logger = Logger("ExtensionRuntime");

  final baseURL = "https://nettruyenco.vn";

  initRuntime(Extension ext) async {
    extension = ext;
    runtime = getJavascriptRuntime();

    runtime.onMessage('request', (dynamic args) async {
      _logger.log("request args ::: $args");
      return await _dio.request<String>(
        args[0],
        data: args[1]['data'],
        queryParameters: args[1]['queryParameters'] ?? {},
        options: Options(
          headers: args[1]['headers'] ?? {},
          method: args[1]['method'] ?? 'get',
          
        ),
      );
    });

    runtime.onMessage('log', (dynamic args) {
      _logger.log(args);
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
    _installExtension();
  }

  _installExtension() async {
    final baseExt = await getExtByUrl(
        "https://raw.githubusercontent.com/lamphuchai-dev/ext-book/main/base/base_ext.js");
    runtime.evaluate(baseExt);

    // final extScript = await getExtByUrl(extension.script);
    final extScript = netTruyen;
    final ext = extScript.replaceAll(
        RegExp(r'export default class.*'), 'class Ext extends Extension {');
    JsEvalResult jsResult = await runtime.evaluateAsync('''
    $ext
    var extension = new Ext();
       extension.load().then(()=>{
        return true;
      });
    ''');
    final value = await runtime.handlePromise(jsResult);
    _logger.log("Extension : $value");
  }

  Future<String> getExtByUrl(String url) async {
    final res = await _dio.get(url);

    return res.data;
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
      _logger.error(e);
      rethrow;
    }
  }

  detail() async {
    // final tmp = await runtime.handlePromise(await runtime.evaluateAsync(
    //     'stringify(()=>extension.detail("https://www.nettruyenus.com/truyen-tranh/thien-ma-than-quyet-trung-sinh-461830"))'));

    // _logger.log(tmp);

    final result = await _runExtension(() async {
      return await runtime.handlePromise(await runtime.evaluateAsync(
          'stringify(()=>extension.detail("https://www.nettruyenus.com/truyen-tranh/thien-ma-than-quyet-trung-sinh-461830"))'));
    });

    _logger.log(result);
  }

  dynamic _decodeValue(String string) {
    return jsonDecode(jsonDecode(string));
  }

  home() async {
    final tmp = await runtime.handlePromise(
        await runtime.evaluateAsync('stringify(()=>extension.home())'));

    if (!tmp.isError) {
      final list = jsonDecode(json.decode(tmp.stringResult));

      final url = extension.source + list[0]["url"];

      // final result = await runtime.handlePromise(await runtime
      //     .evaluateAsync('stringify(()=>extension.itemHome("$url",0))'));

      final listB = await getListBook(url: url);

      _logger.log(listB.length);
    }
  }

  Future<List<Book>> getListBook({required String url, int? page}) async {
    return _runExtension(() async {
      final jsResult = await runtime.handlePromise(await runtime
          .evaluateAsync('stringify(()=>extension.itemHome("$url",$page))'));
      return _decodeValue(jsResult.stringResult)
          .map<Book>((e) => Book.fromMap(e))
          .toList();
    });
  }

  chapter() async {
    final tmp = await runtime.handlePromise(await runtime.evaluateAsync(
        'stringify(()=>extension.chapter("https://www.nettruyenus.com/truyen-tranh/thien-ma-than-quyet-trung-sinh/chap-97/1059055"))'));

    _logger.log(tmp);
  }

  search() async {
    final tmp = await runtime.handlePromise(await runtime.evaluateAsync(
        'stringify(()=>extension.search("https://nettruyenco.vn/tim-truyen","tu tien",2))'));

    _logger.log(tmp.rawResult.runtimeType);
  }
}
