// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// import 'book_chapter.dart';

// // ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'package:u_book/data/models/chapter.dart';
import 'package:u_book/data/models/extension.dart';

part 'book_model.g.dart';

@Collection()
class BookModel {
  final id = Isar.autoIncrement;
  String? name;
  String? bookUrl;
  String? author;
  String? description;
  String? cover;
  String? host;
  int? totalChapter;
  BookModel({
    this.name,
    this.bookUrl,
    this.author,
    this.description,
    this.cover,
    this.host,
    this.totalChapter,
  });

  @override
  String toString() {
    return 'BookModel(name: $name, bookUrl: $bookUrl, author: $author, description: $description, cover: $cover, host: $host, totalChapter: $totalChapter)';
  }
}
