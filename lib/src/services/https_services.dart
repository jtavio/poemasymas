import 'dart:convert';

import 'package:app_poemas/src/models/author_query.dart';
import 'package:app_poemas/src/models/author_title.dart';
import 'package:http/http.dart';

import 'package:app_poemas/src/models/author_item_model.dart';
import 'package:app_poemas/src/models/authors_model.dart';

class HttpServices {
  final url = 'https://poetrydb.org/';
  Future<Authors?> getAllAuthors() async {
    try {
      final resp = await get(Uri.parse('$url/author'));
      final data = getAuthorsFromJson(resp.body);
      print('getAllAuthors $data');
      return data;
    } catch (e) {
      print('errors $e');
      return null;
    }
  }

  Future<List<QueryAuthors>?> queryAuthors(String query) async {
    try {
      final resp = await get(Uri.parse('$url/author/$query/author'));
      final data = queryAuthorsFromJson(resp.body);
      var seen = Set<String>();
      List<QueryAuthors> newArr =
          data.where((st) => seen.add(st.author)).toList();
      //final newDataArr = data.retainWhere((item) => dataArr.remove(item.author));
      print('queryAuthors $newArr');
      return newArr;
    } catch (e) {
      print('errors $e');
      return null;
    }
  }

  Future<List<AuthorItem>> getItemsAuthor(String query) async {
    final resp =
        await get(Uri.parse('$url/author/$query/author,title,linecount'));
    final data = authorItemFromJson(resp.body);
    print('getItemsAuthor ${resp.body}');
    return data;
  }

  Future<List<TitleByAuthor>> getTitlePoem(String name, String title) async {
    final resp = await get(Uri.parse('$url/author,title/$name;$title'));
    final data = titleByAuthorFromJson(resp.body);
    print('getTitlePoem ${resp.body}');
    return data;
  }
}
