import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'chapter.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

enum BookType { novel, comic }

class Book extends Equatable {
  final String name;
  final String url;
  final String author;
  final String description;
  final String cover;
  final String host;
  final int chapterCount;
  final List<Chapter> chapters;
  final int readChapterIndex;
  final BookType type;
  const Book(
      {required this.name,
      required this.url,
      required this.author,
      required this.description,
      required this.cover,
      required this.host,
      required this.chapterCount,
      required this.chapters,
      required this.readChapterIndex,
      required this.type});

  Book copyWith(
      {String? name,
      String? url,
      String? author,
      String? description,
      String? cover,
      String? host,
      int? chapterCount,
      List<Chapter>? chapters,
      int? readChapterIndex,
      BookType? type}) {
    return Book(
        name: name ?? this.name,
        url: url ?? this.url,
        author: author ?? this.author,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        host: host ?? this.host,
        chapterCount: chapterCount ?? this.chapterCount,
        chapters: chapters ?? this.chapters,
        readChapterIndex: readChapterIndex ?? this.readChapterIndex,
        type: type ?? this.type);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'url': url,
      'author': author,
      'description': description,
      'cover': cover,
      'host': host,
      'chapterCount': chapterCount,
      'chapters': chapters.map((x) => x.toMap()).toList(),
      'type': type.name,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
        name: map['name'] ?? "",
        url: map['url'] ?? "",
        author: map['author'] ?? "",
        description: map['description'] ?? "",
        cover: map['cover'] ?? "",
        host: map['host'] ?? "",
        chapterCount: map['chapter_count'] ?? 0,
        readChapterIndex: map['read_chapter_index'] ?? 0,
        chapters: map['chapters'] == null
            ? []
            : List<Chapter>.from(
                (map['chapters']).map<Chapter>(
                  (x) => Chapter.fromMap(x as Map<String, dynamic>),
                ),
              ),
        type: BookType.values.firstWhere(
          (element) => element.name == map["type"],
          orElse: () => BookType.novel,
        ));
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      url,
      author,
      description,
      cover,
      host,
      chapterCount,
      chapters,
    ];
  }
}
