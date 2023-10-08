import 'dart:convert';

import 'package:isar/isar.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first
part 'extension.g.dart';

enum ExtensionType { novel, comic }

@Collection()
class Extension {
  final Id? id;
  final String name;
  @Index(name: 'name&source', composite: [CompositeIndex('source')])
  final String author;
  final int version;
  final String source;
  final String regexp;
  final String description;
  final String locale;
  final String language;
  @Enumerated(EnumType.ordinal)
  final ExtensionType type;
  final String script;
  final String? jsScript;
  final List<TabsHome> tabsHome;
  final bool enableSearch;
  final bool enableGenre;
  @Index()
  final bool isPrimary;

  const Extension(
      {this.id,
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
      this.jsScript,
      required this.tabsHome,
      required this.enableSearch,
      required this.enableGenre,
      required this.isPrimary});

  Extension copyWith(
      {Id? id,
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
      String? jsScript,
      List<TabsHome>? tabsHome,
      bool? enableSearch,
      bool? enableGenre,
      bool? isPrimary}) {
    return Extension(
        id: id ?? this.id,
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
        jsScript: jsScript ?? this.jsScript,
        tabsHome: tabsHome ?? this.tabsHome,
        enableSearch: enableSearch ?? this.enableSearch,
        enableGenre: enableGenre ?? this.enableGenre,
        isPrimary: isPrimary ?? this.isPrimary);
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
      'jsScript': jsScript,
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
        jsScript: map['jsScript'],
        tabsHome: map['tabsHome'] != null
            ? List<TabsHome>.from(
                (map['tabsHome']).map<TabsHome>(
                  (x) => TabsHome.fromMap((x as Map).cast<String, dynamic>()),
                ),
              )
            : [],
        enableSearch: map['enableSearch'] as bool,
        enableGenre: map['enableGenre'] as bool,
        isPrimary: map["isPrimary"] ?? false);
  }

  String toJson() => json.encode(toMap());

  factory Extension.fromJson(String source) =>
      Extension.fromMap(json.decode(source) as Map<String, dynamic>);
}

@embedded
class TabsHome {
  final String? url;
  final String? title;
  const TabsHome({
    this.url,
    this.title,
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
}
