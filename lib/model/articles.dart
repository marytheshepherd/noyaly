import 'package:flutter/material.dart';

class Article {
  final String title;
  final String imageUrl;
  final Color tileColor;
  final String url;

  const Article({
    required this.title,
    required this.imageUrl,
    required this.tileColor,
    required this.url,
  });
}
