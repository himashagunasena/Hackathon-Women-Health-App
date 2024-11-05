import 'dart:async';

import 'package:blossom_health_app/models/article_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Article>> fetchArticles() async {
  final snapshot =
      await FirebaseFirestore.instance.collection('articles').get();

  var articles =
      snapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
  return articles;
}
