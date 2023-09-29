import 'dart:convert';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

enum ExtensionType { novel, comic }

class Extension {
  final String name;
  final String author;
  int version;
  final String source;
  final String regexp;
  final String description;
  final String locale;
  final String language;
  final ExtensionType type;
  final String script;
  final String pathScript;
  Extension({
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
    };
  }

  factory Extension.fromMap(Map<String, dynamic> map) {
    return Extension(
      name: map['name'] ?? "",
      author: map['author'] ?? "",
      version: map['version'] ?? 0,
      source: map['source'] ?? "",
      regexp: map['regexp'] ?? "",
      description: map['description'] ?? "",
      locale: map['locale'] ?? "",
      language: map['language'] ?? "",
      type: ExtensionType.values.firstWhere(
        (type) => type.name == map["type"],
        orElse: () => ExtensionType.novel,
      ),
      script: map['script'] ?? "",
      pathScript: map['pathScript'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Extension.fromJson(String source) =>
      Extension.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Extension(name: $name, author: $author, version: $version, source: $source, regexp: $regexp, description: $description, locale: $locale, language: $language, type: $type, script: $script, pathScript: $pathScript)';
  }

  @override
  bool operator ==(covariant Extension other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.author == author &&
        other.version == version &&
        other.source == source &&
        other.regexp == regexp &&
        other.description == description &&
        other.locale == locale &&
        other.language == language &&
        other.type == type &&
        other.script == script &&
        other.pathScript == pathScript;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        author.hashCode ^
        version.hashCode ^
        source.hashCode ^
        regexp.hashCode ^
        description.hashCode ^
        locale.hashCode ^
        language.hashCode ^
        type.hashCode ^
        script.hashCode ^
        pathScript.hashCode;
  }
}
