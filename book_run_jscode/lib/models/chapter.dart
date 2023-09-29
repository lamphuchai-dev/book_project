import 'dart:convert';

import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ComicContent {
  final String url;
  final String? other;
  ComicContent({
    required this.url,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'other': other,
    };
  }

  factory ComicContent.fromMap(Map<String, dynamic> map) {
    return ComicContent(
      url: map['url'] ?? "",
      other: map['other'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ComicContent.fromJson(String source) =>
      ComicContent.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Chapter extends Equatable {
  final String id;
  final String bookId;
  final String name;
  final String? slug;
  final String publishedAt;
  final String? content;
  final String? url;
  final ComicContent? comicContent;
  const Chapter({
    required this.id,
    required this.bookId,
    required this.name,
    this.slug,
    required this.publishedAt,
    this.content,
    this.url,
    this.comicContent,
  });

  Chapter copyWith({
    String? id,
    String? bookId,
    String? name,
    String? slug,
    String? publishedAt,
    String? content,
    String? url,
    ComicContent? comicContent,
  }) {
    return Chapter(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      url: url ?? this.url,
      comicContent: comicContent ?? this.comicContent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bookId': bookId,
      'name': name,
      'slug': slug,
      'publishedAt': publishedAt,
      'content': content,
      'url': url,
      'comicContent': comicContent?.toMap(),
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      id: map['id'] ?? "",
      bookId: map['bookId'] ?? "",
      name: map['name'] ?? "",
      slug: map['slug'] != null ? map['slug'] ?? "" : null,
      publishedAt: map['publishedAt'] ?? "",
      content: map['content'] != null ? map['content'] ?? "" : null,
      url: map['url'] != null ? map['url'] ?? "" : null,
      comicContent: map['comicContent'] != null
          ? ComicContent.fromMap(map['comicContent'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      bookId,
      name,
      slug,
      publishedAt,
      content,
      url,
      comicContent,
    ];
  }
}
