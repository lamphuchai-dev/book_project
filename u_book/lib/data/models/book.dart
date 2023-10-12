// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// import 'book_chapter.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:u_book/data/models/extension.dart';

part 'book.g.dart';

enum BookType { novel, comic }

@Collection()
class Book {
  final Id? id;
  @Index()
  final String name;
  final String bookUrl;
  final String author;
  final String description;
  final String cover;
  @Index()
  final String host;
  final int totalChapter;
  @Enumerated(EnumType.ordinal)
  final BookType type;
  final bool bookmark;
  final int? currentReadChapter;
  final DateTime? updateAt;
  const Book(
      {this.id,
      required this.name,
      required this.bookUrl,
      required this.author,
      required this.description,
      required this.cover,
      required this.host,
      required this.totalChapter,
      required this.type,
      required this.bookmark,
      this.currentReadChapter,
      this.updateAt});

  Book copyWith(
      {Id? id,
      String? name,
      String? bookUrl,
      String? author,
      String? description,
      String? cover,
      String? host,
      int? totalChapter,
      BookType? type,
      bool? bookmark,
      int? currentReadChapter,
      DateTime? updateAt}) {
    return Book(
        id: id ?? this.id,
        name: name ?? this.name,
        bookUrl: bookUrl ?? this.bookUrl,
        author: author ?? this.author,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        host: host ?? this.host,
        totalChapter: totalChapter ?? this.totalChapter,
        type: type ?? this.type,
        bookmark: bookmark ?? this.bookmark,
        currentReadChapter: currentReadChapter ?? this.currentReadChapter,
        updateAt: updateAt ?? this.updateAt);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'bookUrl': bookUrl,
      'author': author,
      'description': description,
      'cover': cover,
      'host': host,
      'totalChapter': totalChapter,
      'type': type.name
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        name: map['name'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        author: map['author'] ?? "",
        description: map['description'] ?? "",
        cover: map['cover'] ?? "",
        host: map['host'] ?? "",
        totalChapter: map['totalChapter'] ?? 0,
        type: BookType.values.firstWhere(
          (element) => element.name == map["type"],
          orElse: () => BookType.novel,
        ),
        bookmark: map["bookmark"] ?? false,
        currentReadChapter: map["currentReadChapter"],
        updateAt: map["updateAt"]);
  }

  factory Book.fromMapComic(Map<String, dynamic> map) {
    return Book.fromMap({...map, "type": "comic"});
  }

  factory Book.fromMapNovel(Map<String, dynamic> map) {
    return Book.fromMap({...map, "type": "novel"});
  }

  factory Book.fromExtensionType(
      ExtensionType extType, Map<String, dynamic> map) {
    return switch (extType) {
      ExtensionType.comic => Book.fromMapComic(map),
      ExtensionType.novel => Book.fromMapNovel(map),
    };
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);
}
