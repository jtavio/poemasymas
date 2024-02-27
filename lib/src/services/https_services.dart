import 'dart:convert';

import 'package:app_poemas/src/models/data_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpServices {
  final db = FirebaseFirestore.instance;
  final dio = Dio();

  Future getItemsAuthor(String? id) async {
    final ref = db.collection("authors").doc(id).withConverter(
          fromFirestore: Author.fromFirestore,
          toFirestore: (Author city, _) => city.toFirestore(),
        );
    final docSnap = await ref.get();
    final authorId = docSnap.data();
    debugPrint('data $authorId');
    return authorId;

    // final resp =
    //     await get(Uri.parse('$url/author/$query/author,title,linecount'));
    // final data = authorItemFromJson(resp.body);
    // print('getItemsAuthor ${resp.body}');
    // return data;
  }

  Future addLike(String? id, int? more) async {
    final likeRef = db.collection("authors").doc(id);
    likeRef.update({"likes": more});
  }

  Future sendNotification(String dataUser) async {
    try {
      final response =
          await dio.post('https://firebase-get-poems-1.onrender.com/send', data: jsonEncode({"token": dataUser}));
      debugPrint('response ${response.data}');
    } catch (e) {
      debugPrint('error ${e.toString()}');
    }
  }

  // Future<List<TitleByAuthor>> getTitlePoem(String name, String title) async {
  //   final resp = await get(Uri.parse('$url/author,title/$name;$title'));
  //   final data = titleByAuthorFromJson(resp.body);
  //   print('getTitlePoem ${resp.body}');
  //   return data;
  // }

  Future<bool> addPoemsAuthor(Map<String, dynamic> value) async {
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
