import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Article {
  final String title;
  final String url;
  final String imageUrl;
  final Color tileColor;

  Article({
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.tileColor,
  });

  factory Article.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return Article(
      title: doc.get('title') as String,
      url: doc.get('url') as String,
      imageUrl: doc.get('imageUrl') as String,
      tileColor: const Color(0xFFD9FFE6),
    );
  }
}
