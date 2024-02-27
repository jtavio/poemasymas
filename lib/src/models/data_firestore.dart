import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  final String? author;
  final List<String>? lineas;
  final String? title;
  final int? likes;
  final String? idfcm;

  Author({this.author, this.lineas, this.title, this.likes, this.idfcm});

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
      idfcm: data?['idfcm'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (author != null) "author": author,
      if (lineas != null) "regions": lineas,
      if (title != null) "title": title,
      if (likes != null) "likes": likes,
      if (idfcm != null) "likes": idfcm,
    };
  }
}
