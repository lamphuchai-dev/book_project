// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// import 'book_chapter.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/data/models/extension.dart';

enum BookType { novel, comic }

class Book extends Equatable {
  final String name;
  final String bookUrl;
  final String author;
  final String description;
  final String cover;
  final String host;
  final int totalChapter;
  final BookType type;
  final List<Chapter> chapters;
  const Book(
      {required this.name,
      required this.bookUrl,
      required this.author,
      required this.description,
      required this.cover,
      required this.host,
      required this.totalChapter,
      required this.type,
      required this.chapters});

  Book copyWith(
      {String? name,
      String? bookUrl,
      String? author,
      String? description,
      String? cover,
      String? host,
      int? totalChapter,
      BookType? type,
      List<Chapter>? chapters}) {
    return Book(
        name: name ?? this.name,
        bookUrl: bookUrl ?? this.bookUrl,
        author: author ?? this.author,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        host: host ?? this.host,
        totalChapter: totalChapter ?? this.totalChapter,
        type: type ?? this.type,
        chapters: chapters ?? this.chapters);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
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
        chapters: map["chapters"] != null
            ? (map["chapters"])
                .map<Chapter>((chapter) => Chapter.fromMap(chapter))
                .toList()
            : [],
        type: BookType.values.firstWhere(
          (element) => element.name == map["type"],
          orElse: () => BookType.novel,
        ));
  }

  factory Book.fromMapComic(Map<String, dynamic> map) {
    return Book(
        name: map['name'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        author: map['author'] ?? "",
        description: map['description'] ?? "",
        cover: map['cover'] ?? "",
        host: map['host'] ?? "",
        totalChapter: map['totalChapter'] ?? 0,
        chapters: map["chapters"] != null
            ? (map["chapters"])
                .map<Chapter>((chapter) => Chapter.fromMap(chapter))
                .toList()
            : [],
        type: BookType.comic);
  }

  factory Book.fromMapNovel(Map<String, dynamic> map) {
    return Book(
        name: map['name'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        author: map['author'] ?? "",
        description: map['description'] ?? "",
        cover: map['cover'] ?? "",
        host: map['host'] ?? "",
        totalChapter: map['totalChapter'] ?? 0,
        chapters: map["chapters"] != null
            ? (map["chapters"])
                .map<Chapter>((chapter) => Chapter.fromMap(chapter))
                .toList()
            : [],
        type: BookType.novel);
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

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      name,
      bookUrl,
      author,
      description,
      cover,
      host,
      totalChapter,
      type,
    ];
  }

  static Book bookTest() {
    return const Book(
        name: "TA TRỞ VỀ TỪ CHƯ THIÊN VẠN GIỚI",
        bookUrl:
            "https://www.nettruyenus.com/truyen-tranh/ta-tro-ve-tu-chu-thien-van-gioi-380100",
        author: "Đang cập nhật",
        description:
            "Truyện tranh Ta Trở Về Từ Chư Thiên Vạn Giới được cập nhật nhanh và đầy đủ nhất tại NetTruyen. Bạn đọc đừng quên để lại bình luận và chia sẻ, ủng hộ NetTruyen ra các chương mới nhất của truyện Ta Trở Về Từ Chư Thiên Vạn Giới.",
        cover:
            "https://st.nettruyenus.com/data/comics/122/ta-tro-ve-tu-chu-thien-van-gioi.jpg",
        host: "https://www.nettruyenus.com",
        totalChapter: 12,
        chapters: [],
        type: BookType.comic);
  }
}
