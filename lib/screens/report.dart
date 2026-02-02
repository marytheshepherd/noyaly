import 'package:flutter/material.dart';
import '../widgets/b_nav.dart';
import '../widgets/t_nav.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNav(leading: Icon(Icons.read_more_outlined)),
      body: const Center(
        child: Text("Report Screen 👤", style: TextStyle(fontSize: 24)),
      ),
      bottomNavigationBar: SafeArea(child: BottomNav(currentRoute: "/report")),
    );
  }
}
