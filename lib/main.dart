import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'logic/auth.dart';

import 'screens/report.dart';
import 'screens/home.dart';
import 'screens/articles.dart';
import 'screens/questions.dart';
import 'screens/profiles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      home: const AuthGate(),
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
