import 'dart:convert';

import 'package:app_poemas/src/models/author_query.dart';
import 'package:app_poemas/src/models/author_title.dart';
import 'package:app_poemas/src/models/data_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/src/widgets/editable_text.dart';
import 'package:http/http.dart';

import 'package:app_poemas/src/models/author_item_model.dart';
import 'package:app_poemas/src/models/authors_model.dart';

class HttpServices {
  final db = FirebaseFirestore.instance;

  // final url = 'https://poetrydb.org/';

  // Future<List<QueryAuthors>?> queryAuthors(String query) async {
  //   try {
  //     final resp = await get(Uri.parse('$url/author/$query/author'));
  //     final data = queryAuthorsFromJson(resp.body);
  //     var seen = Set<String>();
  //     List<QueryAuthors> newArr =
  //         data.where((st) => seen.add(st.author)).toList();
  //     //final newDataArr = data.retainWhere((item) => dataArr.remove(item.author));
  //     print('queryAuthors $newArr');
  //     return newArr;
  //   } catch (e) {
  //     print('errors $e');
  //     return null;
  //   }
  // }

  Future getItemsAuthor(String id) async {
    final ref = db.collection("authors").doc(id).withConverter(
          fromFirestore: Author.fromFirestore,
          toFirestore: (Author city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    final authorId = docSnap.data();
    print('data $authorId');
    return authorId;

    // final resp =
    //     await get(Uri.parse('$url/author/$query/author,title,linecount'));
    // final data = authorItemFromJson(resp.body);
    // print('getItemsAuthor ${resp.body}');
    // return data;
  }

  // Future<List<TitleByAuthor>> getTitlePoem(String name, String title) async {
  //   final resp = await get(Uri.parse('$url/author,title/$name;$title'));
  //   final data = titleByAuthorFromJson(resp.body);
  //   print('getTitlePoem ${resp.body}');
  //   return data;
  // }

  Future<bool> addPoemsAuthor(String id, Map<String, dynamic> value) async {
    // final data5 = <String, dynamic>{
    //   "name": "Beijing",
    //   "state": null,
    //   "country": "China",
    //   "capital": true,
    //   "population": 21500000,
    //   "regions": ["jingjinji", "hebei"],
    // };
    // db.collection("authors").doc(id).set(value);
    bool a = await db.collection('authors').doc().set(value).then(
          (onValue) => true,
          onError: (e) => false,
        );
    return a;
  }
}
