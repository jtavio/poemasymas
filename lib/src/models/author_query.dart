// To parse this JSON data, do
//
//     final queryAuthors = queryAuthorsFromJson(jsonString);

import 'dart:convert';

List<QueryAuthors> queryAuthorsFromJson(String str) => List<QueryAuthors>.from(
    json.decode(str).map((x) => QueryAuthors.fromJson(x)));

String queryAuthorsToJson(List<QueryAuthors> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QueryAuthors {
  QueryAuthors({
    required this.author,
  });

  String author;

  factory QueryAuthors.fromJson(Map<String, dynamic> json) => QueryAuthors(
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "author": author,
      };
}
