// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// import 'book_chapter.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';

enum BookType { novel, comic }

// class Book extends Equatable {
//   final String name;
//   final String url;
//   final String author;
//   final String description;
//   final String cover;
//   final String host;
//   final int chapterCount;
//   final List<Chapter> chapters;
//   final int currentReadChapter;
//   final BookType type;

//   const Book(
//       {required this.name,
//       required this.url,
//       required this.author,
//       required this.description,
//       required this.cover,
//       required this.host,
//       required this.chapterCount,
//       required this.chapters,
//       required this.currentReadChapter,
//       required this.type});

//   Book copyWith(
//       {String? name,
//       String? url,
//       String? author,
//       String? description,
//       String? cover,
//       String? host,
//       int? chapterCount,
//       List<Chapter>? chapters,
//       int? currentReadChapter,
//       BookType? type}) {
//     return Book(
//         name: name ?? this.name,
//         url: url ?? this.url,
//         author: author ?? this.author,
//         description: description ?? this.description,
//         cover: cover ?? this.cover,
//         host: host ?? this.host,
//         chapterCount: chapterCount ?? this.chapterCount,
//         chapters: chapters ?? this.chapters,
//         currentReadChapter: currentReadChapter ?? this.currentReadChapter,
//         type: type ?? this.type);
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'name': name,
//       'url': url,
//       'author': author,
//       'description': description,
//       'cover': cover,
//       'host': host,
//       'chapterCount': chapterCount,
//       'chapters': chapters.map((x) => x.toMap()).toList(),
//       'type': type.name,
//     };
//   }

//   factory Book.fromMap(Map<String, dynamic> map) {
//     return Book(
//         name: map['name'] ?? "",
//         url: map['url'] ?? "",
//         author: map['author'] ?? "",
//         description: map['description'] ?? "",
//         cover: map['cover'] ?? "",
//         host: map['host'] ?? "",
//         chapterCount: map['chapter_count'] ?? 0,
//         currentReadChapter: map['read_chapter_index'] ?? 0,
//         chapters: map['chapters'] == null
//             ? []
//             : List<Chapter>.from(
//                 (map['chapters']).map<Chapter>(
//                   (x) => Chapter.fromMap(x as Map<String, dynamic>),
//                 ),
//               ),
//         type: BookType.values.firstWhere(
//           (element) => element.name == map["type"],
//           orElse: () => BookType.novel,
//         ));
//   }

//   factory Book.fromMapTypeComic(Map<String, dynamic> map) {
//     return Book(
//         name: map['name'] ?? "",
//         url: map['url'] ?? "",
//         author: map['author'] ?? "",
//         description: map['description'] ?? "",
//         cover: map['cover'] ?? "",
//         host: map['host'] ?? "",
//         chapterCount: map['chapter_count'] ?? 0,
//         currentReadChapter: map['read_chapter_index'] ?? 0,
//         chapters: map['chapters'] == null
//             ? []
//             : List<Chapter>.from(
//                 (map['chapters']).map<Chapter>(
//                   (x) => Chapter.fromMap(x as Map<String, dynamic>),
//                 ),
//               ),
//         type: BookType.comic);
//   }

//   factory Book.fromMapTypeNovel(Map<String, dynamic> map) {
//     return Book(
//         name: map['name'] ?? "",
//         url: map['url'] ?? "",
//         author: map['author'] ?? "",
//         description: map['description'] ?? "",
//         cover: map['cover'] ?? "",
//         host: map['host'] ?? "",
//         chapterCount: map['chapter_count'] ?? 0,
//         currentReadChapter: map['read_chapter_index'] ?? 0,
//         chapters: map['chapters'] == null
//             ? []
//             : List<Chapter>.from(
//                 (map['chapters']).map<Chapter>(
//                   (x) => Chapter.fromMap(x as Map<String, dynamic>),
//                 ),
//               ),
//         type: BookType.novel);
//   }

//   String toJson() => json.encode(toMap());

//   factory Book.fromJson(String source) =>
//       Book.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   bool get stringify => true;

//   @override
//   List<Object> get props {
//     return [
//       name,
//       url,
//       author,
//       description,
//       cover,
//       host,
//       chapterCount,
//       chapters,
//     ];
//   }

//   static Book bookTest() {
//     return const Book(
//         name: "TA TRỞ VỀ TỪ CHƯ THIÊN VẠN GIỚI",
//         url:
//             "https://www.nettruyenus.com/truyen-tranh/ta-tro-ve-tu-chu-thien-van-gioi-380100",
//         author: "Đang cập nhật",
//         description:
//             "Truyện tranh Ta Trở Về Từ Chư Thiên Vạn Giới được cập nhật nhanh và đầy đủ nhất tại NetTruyen. Bạn đọc đừng quên để lại bình luận và chia sẻ, ủng hộ NetTruyen ra các chương mới nhất của truyện Ta Trở Về Từ Chư Thiên Vạn Giới.",
//         cover:
//             "https://st.nettruyenus.com/data/comics/122/ta-tro-ve-tu-chu-thien-van-gioi.jpg",
//         host: "https://www.nettruyenus.com",
//         chapterCount: 12,
//         chapters: [],
//         currentReadChapter: 1,
//         type: BookType.comic);
//   }
// }

// extension BookExtension on Book {
//   String get getPercentRead =>
//       ((currentReadChapter / chapterCount) * 100).toStringAsFixed(2);
// }

class Book extends Equatable {
  final String name;
  final String bookUrl;
  final String author;
  final String description;
  final String cover;
  final String host;
  final int totalChapter;
  final BookType type;
  const Book({
    required this.name,
    required this.bookUrl,
    required this.author,
    required this.description,
    required this.cover,
    required this.host,
    required this.totalChapter,
    required this.type,
  });

  Book copyWith({
    String? name,
    String? bookUrl,
    String? author,
    String? description,
    String? cover,
    String? host,
    int? totalChapter,
    BookType? type,
  }) {
    return Book(
      name: name ?? this.name,
      bookUrl: bookUrl ?? this.bookUrl,
      author: author ?? this.author,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      host: host ?? this.host,
      totalChapter: totalChapter ?? this.totalChapter,
      type: type ?? this.type,
    );
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
        name: map['name'] as String,
        bookUrl: map['bookUrl'] as String,
        author: map['author'] as String,
        description: map['description'] as String,
        cover: map['cover'] as String,
        host: map['host'] as String,
        totalChapter: map['totalChapter'] as int,
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
        type: BookType.novel);
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
        type: BookType.comic);
  }
}
