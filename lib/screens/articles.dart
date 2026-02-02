import 'package:flutter/material.dart';
import '../widgets/b_nav.dart';
import '../widgets/t_nav.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNav(leading: Icon(Icons.book_outlined)),
      body: SafeArea(
        child: Center(
          child: Text("Articles Screen 👤", style: TextStyle(fontSize: 24)),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNav(currentRoute: "/articles"),
      ),
    );
  }
}
