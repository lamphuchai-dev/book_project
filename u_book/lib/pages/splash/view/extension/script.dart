// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Script {
  String? home;
  String? detail;
  String? chapters;
  String? chapter;
  String? search;
  String? genre;
  Script({
    this.home,
    this.detail,
    this.chapters,
    this.chapter,
    this.search,
    this.genre,
  });

  Script copyWith({
    String? home,
    String? detail,
    String? chapters,
    String? chapter,
    String? search,
    String? genre,
  }) {
    return Script(
      home: home ?? this.home,
      detail: detail ?? this.detail,
      chapters: chapters ?? this.chapters,
      chapter: chapter ?? this.chapter,
      search: search ?? this.search,
      genre: genre ?? this.genre,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'home': home,
      'detail': detail,
      'chapters': chapters,
      'chapter': chapter,
      'search': search,
      'genre': genre,
    };
  }

  factory Script.fromMap(Map<String, dynamic> map) {
    return Script(
      home: map['home'] != null ? map['home'] as String : null,
      detail: map['detail'] != null ? map['detail'] as String : null,
      chapters: map['chapters'] != null ? map['chapters'] as String : null,
      chapter: map['chapter'] != null ? map['chapter'] as String : null,
      search: map['search'] != null ? map['search'] as String : null,
      genre: map['genre'] != null ? map['genre'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Script.fromJson(String source) =>
      Script.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Script(home: $home, detail: $detail, chapters: $chapters, chapter: $chapter, search: $search, genre: $genre)';
  }

  @override
  bool operator ==(covariant Script other) {
    if (identical(this, other)) return true;

    return other.home == home &&
        other.detail == detail &&
        other.chapters == chapters &&
        other.chapter == chapter &&
        other.search == search &&
        other.genre == genre;
  }

  @override
  int get hashCode {
    return home.hashCode ^
        detail.hashCode ^
        chapters.hashCode ^
        chapter.hashCode ^
        search.hashCode ^
        genre.hashCode;
  }
}
