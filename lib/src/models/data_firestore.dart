import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  final String? author;
  final List<String>? lineas;
  final String? title;
  final int? likes;

  Author({
    this.author,
    this.lineas,
    this.title,
    this.likes,
  });

  factory Author.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Author(
      author: data?['author'],
      lineas: data?['lineas'] is Iterable ? List.from(data?['lineas']) : null,
      title: data?['title'],
      likes: data?['likes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (author != null) "author": author,
      if (lineas != null) "regions": lineas,
      if (title != null) "title": title,
      if (likes != null) "likes": likes,
    };
  }
}
