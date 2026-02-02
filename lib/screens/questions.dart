import 'package:flutter/material.dart';
import '../data/question_bank.dart';
import '../logic/logic.dart';
import '../widgets/mood.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentIndex = 0;
  double sliderValue = 2;
  final List<int> answers = [];

  void nextQuestion() {
    final question = questions[currentIndex];

    answers.add(scoreFromIndex(sliderValue.round(), question.reverseScored));

    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        sliderValue = 2;
      });
    } else {
      final totalScore = answers.reduce((a, b) => a + b);
      debugPrint("Total PSS Score: $totalScore");
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.brown),
        title: const Text("Assessment", style: TextStyle(color: Colors.brown)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "${currentIndex + 1} of ${questions.length}",
                style: const TextStyle(color: Colors.brown),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Text(
              "In the last month, how often have you…",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              question.text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.brown),
            ),

            const SizedBox(height: 30),

            MoodFace(value: sliderValue),

            const SizedBox(height: 20),

            Slider(
              value: sliderValue,
              min: 0,
              max: 4,
              divisions: 4,
              activeColor: Color(0xFFFB923C),
              inactiveColor: Colors.brown.shade100,
              onChanged: (value) {
                setState(() => sliderValue = value);
              },
            ),

            const SizedBox(height: 10),

            const Text(
              "Never      Rarely      Sometimes      Often      Very Often",
              style: TextStyle(fontSize: 12, color: Colors.brown),
              textAlign: TextAlign.center,
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4DB6AC),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: nextQuestion,
              child: const Text("Next", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
