import 'dart:convert';

List<TitleByAuthor> titleByAuthorFromJson(String str) =>
    List<TitleByAuthor>.from(
        json.decode(str).map((x) => TitleByAuthor.fromJson(x)));

String titleByAuthorToJson(List<TitleByAuthor> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TitleByAuthor {
  TitleByAuthor({
    required this.title,
    required this.author,
    required this.lines,
    required this.linecount,
  });

  String title;
  String author;
  List<String> lines;
  String linecount;

  factory TitleByAuthor.fromJson(Map<String, dynamic> json) => TitleByAuthor(
        title: json["title"],
        author: json["author"],
        lines: List<String>.from(json["lines"].map((x) => x)),
        linecount: json["linecount"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "lines": List<dynamic>.from(lines.map((x) => x)),
        "linecount": linecount,
      };
}
