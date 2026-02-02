import 'package:flutter/material.dart';
import 'screens/report.dart';
import 'screens/home.dart';
import 'screens/articles.dart';
import 'screens/questions.dart';
import 'screens/profiles.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/articles': (_) => const ArticleScreen(),
        '/report': (_) => const ReportScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/question': (_) => const QuestionScreen(),
      },
    ),
  );
}
