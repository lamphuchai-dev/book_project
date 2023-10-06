import 'dart:convert';

import 'package:equatable/equatable.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

enum ExtensionType { novel, comic }

class Extension extends Equatable {
  final String name;
  final String author;
  final int version;
  final String source;
  final String regexp;
  final String description;
  final String locale;
  final String language;
  final ExtensionType type;
  final String script;
  final String pathScript;
  final List<TabsHome> tabsHome;
  final bool enableSearch;
  final bool enableGenre;
  const Extension({
    required this.name,
    required this.author,
    required this.version,
    required this.source,
    required this.regexp,
    required this.description,
    required this.locale,
    required this.language,
    required this.type,
    required this.script,
    required this.pathScript,
    required this.tabsHome,
    required this.enableSearch,
    required this.enableGenre,
  });

  Extension copyWith({
    String? name,
    String? author,
    int? version,
    String? source,
    String? regexp,
    String? description,
    String? locale,
    String? language,
    ExtensionType? type,
    String? script,
    String? pathScript,
    List<TabsHome>? tabsHome,
    bool? enableSearch,
    bool? enableGenre,
  }) {
    return Extension(
      name: name ?? this.name,
      author: author ?? this.author,
      version: version ?? this.version,
      source: source ?? this.source,
      regexp: regexp ?? this.regexp,
      description: description ?? this.description,
      locale: locale ?? this.locale,
      language: language ?? this.language,
      type: type ?? this.type,
      script: script ?? this.script,
      pathScript: pathScript ?? this.pathScript,
      tabsHome: tabsHome ?? this.tabsHome,
      enableSearch: enableSearch ?? this.enableSearch,
      enableGenre: enableGenre ?? this.enableGenre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'author': author,
      'version': version,
      'source': source,
      'regexp': regexp,
      'description': description,
      'locale': locale,
      'language': language,
      'type': type.name,
      'script': script,
      'pathScript': pathScript,
      'tabsHome': tabsHome.map((x) => x.toMap()).toList(),
      'enableSearch': enableSearch,
      'enableGenre': enableGenre,
    };
  }

  factory Extension.fromMap(Map<String, dynamic> map) {
    return Extension(
      name: map['name'] as String,
      author: map['author'] as String,
      version: map['version'] as int,
      source: map['source'] as String,
      regexp: map['regexp'] as String,
      description: map['description'] as String,
      locale: map['locale'] as String,
      language: map['language'] as String,
      type: ExtensionType.values.firstWhere(
        (type) => type.name == map["type"],
        orElse: () => ExtensionType.novel,
      ),
      script: map['script'] as String,
      pathScript: map['pathScript'] ?? "",
      tabsHome: map['tabsHome'] != null
          ? List<TabsHome>.from(
              (map['tabsHome']).map<TabsHome>(
                (x) => TabsHome.fromMap(x),
              ),
            )
          : [],
      enableSearch: map['enableSearch'] as bool,
      enableGenre: map['enableGenre'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Extension.fromJson(String source) =>
      Extension.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      author,
      version,
      source,
      regexp,
      description,
      locale,
      language,
      type,
      script,
      pathScript,
      tabsHome,
      enableSearch,
      enableGenre,
    ];
  }
}

class TabsHome extends Equatable {
  final String url;
  final String title;
  const TabsHome({
    required this.url,
    required this.title,
  });

  TabsHome copyWith({
    String? url,
    String? title,
  }) {
    return TabsHome(
      url: url ?? this.url,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'title': title,
    };
  }

  factory TabsHome.fromMap(Map<String, dynamic> map) {
    return TabsHome(
      url: map['url'] as String,
      title: map['title'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TabsHome.fromJson(String source) =>
      TabsHome.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [url, title];
}
