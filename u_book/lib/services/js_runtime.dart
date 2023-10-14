// ignore_for_file: unused_element, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_client/index.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:xpath_selector_html_parser/xpath_selector_html_parser.dart';

import 'package:u_book/app/config/app_type.dart';
import 'package:u_book/data/models/book.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/utils/directory_utils.dart';
import 'package:u_book/utils/logger.dart';

class JsRuntime {
  late JavascriptRuntime runtime;

  final _logger = Logger("JsRuntime");
  final _dioClient = DioClient();

  Future<bool> initRuntime() async {
    _dioClient.enableCookie(dir: await DirectoryUtils.getDirectory);
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
      try {
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
      } catch (error) {
        rethrow;
      }
    });

    runtime.onMessage('querySelectorAll', (dynamic args) async {
      try {
        final content = args[0];
        final selector = args[1];
        final doc = parse(content).querySelectorAll(selector);
        final elements = jsonEncode(doc.map((e) {
          return e.outerHtml;
        }).toList());
        return elements;
      } catch (error) {
        rethrow;
      }
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

    final result = runtime.evaluate(_baseJs());
    return result.isError;
  }

  Future<T> _runExtension<T>(Future<T> Function() fun) async {
    try {
      return await fun();
    } catch (e) {
      _logger.error(e, name: "_runExtension");
      rethrow;
    }
  }

  Future<List<Book>> listBook(
      {required String url,
      required int page,
      required String jsScript,
      required ExtensionType extType}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await evaluateAsyncJsScript('stringify(()=>home("$url",$page))'));
      return jsResult.toJson
          .map<Book>((map) => Book.fromExtensionType(extType, map))
          .toList();
    });
  }

  Future<Book?> detail(
      {required String url,
      required String jsScript,
      required ExtensionType extType}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await evaluateAsyncJsScript('stringify(()=>detail("$url"))'));
      return Book.fromExtensionType(extType, jsResult.toJson);
    });
  }

  Future<List<Chapter>> getChapters(
      {required String url, required String jsScript}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await evaluateAsyncJsScript('stringify(()=>chapters("$url"))'));
      List<Chapter> chapters =
          jsResult.toJson.map<Chapter>((map) => Chapter.fromMap(map)).toList();
      chapters.sort((a, b) => a.index.compareTo(b.index));
      return chapters;
    });
  }

  Future<List<String>> chapter(
      {required String url, required String jsScript}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(
          await runtime.evaluateAsync('stringify(()=>chapter("$url"))'));
      return List<String>.from(jsResult.toJson);
    });
  }

  Future<List<Book>> search(
      {required String url,
      required String keyWord,
      int? page,
      required String jsScript,
      required ExtensionType extType}) async {
    return _runExtension(() async {
      evaluateJsScript(jsScript);
      final jsResult = await runtime.handlePromise(await evaluateAsyncJsScript(
          'stringify(()=>search("$url","$keyWord",$page))'));
      return jsResult.toJson
          .map<Book>((map) => Book.fromExtensionType(extType, map))
          .toList();
    });
  }

  bool evaluateJsScript(String code, {bool exception = true}) {
    final jsEvalResult = runtime.evaluate(code);
    if (jsEvalResult.isError && exception) {
      throw const RuntimeException(RuntimeExceptionType.extensionScript);
    }
    return jsEvalResult.isError;
  }

  Future<JsEvalResult> evaluateAsyncJsScript(String code,
      {bool exception = true}) async {
    final jsEvalResult = await runtime.evaluateAsync(code);
    if (jsEvalResult.isError && exception) {
      throw const RuntimeException(RuntimeExceptionType.extensionScript);
    }
    return jsEvalResult;
  }

  String _baseJs() {
    return '''
class Element {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector || "";
  }

  async querySelector(selector) {
    return new Element(await this.excute(), selector);
  }

  async excute(fun) {
    return await sendMessage(
      "querySelector",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  async removeSelector(selector) {
    this.content = await sendMessage(
      "removeSelector",
      JSON.stringify([await this.outerHTML, selector])
    );
    return this;
  }

  async getAttributeText(attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([await this.outerHTML, this.selector, attr])
    );
  }

  get text() {
    return this.excute("text");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }

  get innerHTML() {
    return this.excute("innerHTML");
  }
}
class XPathNode {
  constructor(content, selector) {
    this.content = content;
    this.selector = selector;
  }

  async excute(fun) {
    return await sendMessage(
      "queryXPath",
      JSON.stringify([this.content, this.selector, fun])
    );
  }

  get attr() {
    return this.excute("attr");
  }

  get attrs() {
    return this.excute("attrs");
  }

  get text() {
    return this.excute("text");
  }

  get allHTML() {
    return this.excute("allHTML");
  }

  get outerHTML() {
    return this.excute("outerHTML");
  }
}

class Extension {
  static async request(url, options) {
    options = options || {};
    options.headers = options.headers || {};
    options.method = options.method || "get";
    const res = await sendMessage("request", JSON.stringify([url, options]));
    try {
      return JSON.parse(res);
    } catch (e) {
      return res;
    }
  }
  static querySelector(content, selector) {
    return new Element(content, selector);
  }
  static queryXPath(content, selector) {
    return new XPathNode(content, selector);
  }
  static async querySelectorAll(content, selector) {
    let elements = [];
    JSON.parse(
      await sendMessage("querySelectorAll", JSON.stringify([content, selector]))
    ).forEach((e) => {
      elements.push(new Element(e, selector));
    });
    return elements;
  }
  static async getAttributeText(content, selector, attr) {
    return await sendMessage(
      "getAttributeText",
      JSON.stringify([content, selector, attr])
    );
  }
}

console.log = function (message) {
  if (typeof message === "object") {
    message = JSON.stringify(message);
  }
  sendMessage("log", JSON.stringify([message.toString()]));
};

async function stringify(callback) {
  const data = await callback();
  return typeof data === "object" ? JSON.stringify(data) : data;
}

''';
  }
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

enum RuntimeExceptionType { extensionScript, convertValue, other }

class RuntimeException implements Exception {
  final RuntimeExceptionType type;
  const RuntimeException(this.type);
}