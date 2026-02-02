import 'package:flutter/material.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      body: const Center(
        child: Text("Articles Screen 👤", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
