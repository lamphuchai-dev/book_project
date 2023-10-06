// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'chapter_content.dart';

class Chapter extends Equatable {
  final String title;
  final String url;
  final String bookUrl;
  final int index;
  final List<ComicContent> comicContent;
  final List<String> novelContent;
  const Chapter({
    required this.title,
    required this.url,
    required this.bookUrl,
    required this.index,
    required this.comicContent,
    required this.novelContent,
  });

  Chapter copyWith({
    String? title,
    String? url,
    String? bookUrl,
    int? index,
    List<ComicContent>? comicContent,
    List<String>? novelContent,
  }) {
    return Chapter(
      title: title ?? this.title,
      url: url ?? this.url,
      bookUrl: bookUrl ?? this.bookUrl,
      index: index ?? this.index,
      comicContent: comicContent ?? this.comicContent,
      novelContent: novelContent ?? this.novelContent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'url': url,
      'bookUrl': bookUrl,
      'index': index,
      'comicContent': comicContent.map((x) => x.toMap()).toList(),
      'novelContent': novelContent,
    };
  }

  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
        title: map['title'] ?? "",
        url: map['url'] ?? "",
        bookUrl: map['bookUrl'] ?? "",
        index: map['index'] ?? 0,
        comicContent: map['comicContent'] != null
            ? List<ComicContent>.from(
                (map['comicContent']).map<ComicContent>(
                  (x) => ComicContent.fromMap(x),
                ),
              )
            : [],
        novelContent: map['novelContent'] != null
            ? List<String>.from(
                (map['novelContent']),
              )
            : []);
  }

  String toJson() => json.encode(toMap());

  factory Chapter.fromJson(String source) =>
      Chapter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      title,
      url,
      bookUrl,
      index,
      comicContent,
      novelContent,
    ];
  }
}
