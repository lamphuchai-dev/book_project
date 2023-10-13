// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:u_book/pages/splash/view/extension/script.dart';

import 'metadata.dart';

class ExtensionModel {
  final Metadata metadata;
  final Script script;
  ExtensionModel({
    required this.metadata,
    required this.script,
  });

  ExtensionModel copyWith({
    Metadata? metadata,
    Script? script,
  }) {
    return ExtensionModel(
      metadata: metadata ?? this.metadata,
      script: script ?? this.script,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'metadata': metadata.toMap(),
      'script': script.toMap(),
    };
  }

  factory ExtensionModel.fromMap(Map<String, dynamic> map) {
    return ExtensionModel(
      metadata: Metadata.fromMap(map['metadata'] as Map<String, dynamic>),
      script: Script.fromMap(map['script'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtensionModel.fromJson(String source) =>
      ExtensionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ExtensionModel(metadata: $metadata, script: $script)';

  @override
  bool operator ==(covariant ExtensionModel other) {
    if (identical(this, other)) return true;

    return other.metadata == metadata && other.script == script;
  }

  @override
  int get hashCode => metadata.hashCode ^ script.hashCode;

}
