import 'dart:convert';

Authors getAuthorsFromJson(String str) => Authors.fromJson(json.decode(str));

String getAuthorsToJson(Authors data) => json.encode(data.toJson());

class Authors {
  Authors({
    required this.authors,
  });

  List<String> authors;

  factory Authors.fromJson(Map<String, dynamic> json) => Authors(
        authors: List<String>.from(json["authors"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "authors": List<dynamic>.from(authors.map((x) => x)),
      };
}
