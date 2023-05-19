import 'dart:convert';

List<AuthorItem> authorItemFromJson(String str) =>
    List<AuthorItem>.from(json.decode(str).map((x) => AuthorItem.fromJson(x)));

String authorItemToJson(List<AuthorItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AuthorItem {
  AuthorItem({
    required this.title,
    this.author,
    this.linecount,
  });

  String title;
  String? author;
  String? linecount;

  factory AuthorItem.fromJson(Map<String, dynamic> json) => AuthorItem(
        title: json["title"],
        author: json["author"],
        linecount: json["linecount"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "author": author,
        "linecount": linecount,
      };
}
