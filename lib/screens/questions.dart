import 'package:flutter/material.dart';
import '../data/question_bank.dart';
import '../logic/scoring.dart';
import '../widgets/mood.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int pageIndex = 0;
  final int questionsPerPage = 2;

  late List<double> sliderValues;

  @override
  void initState() {
    super.initState();
    sliderValues = List.filled(questions.length, 2); // default: "Sometimes"
  }

  void nextPage() {
    final bool isLastPage =
        (pageIndex + 1) * questionsPerPage >= questions.length;

    if (isLastPage) {
      final answers = <int>[];

      for (int i = 0; i < questions.length; i++) {
        answers.add(
          scoreFromIndex(sliderValues[i].round(), questions[i].reverseScored),
        );
      }

      final totalScore = answers.reduce((a, b) => a + b);

      Navigator.pushReplacementNamed(context, '/report', arguments: totalScore);
    } else {
      setState(() {
        pageIndex++;
      });
    }
  }

  void prevPage() {
    if (pageIndex > 0) {
      setState(() {
        pageIndex--;
      });
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }

  Widget buildQuestionBlock(int index) {
    final question = questions[index];

    return Column(
      children: [
        Text(
          question.text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.brown),
        ),

        const SizedBox(height: 20),

        MoodFace(value: sliderValues[index]),

        const SizedBox(height: 20),

        Row(
          children: [
            const Text(
              "Never",
              style: TextStyle(fontSize: 12, color: Colors.brown),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Slider(
                value: sliderValues[index], // or sliderValue if single
                min: 0,
                max: 4,
                divisions: 4,
                activeColor: const Color(0xFFFB923C),
                inactiveColor: Colors.brown.shade100,
                onChanged: (value) {
                  setState(() {
                    sliderValues[index] = value; // or sliderValue = value
                  });
                },
              ),
            ),

            const SizedBox(width: 8),

            const Text(
              "Very Often",
              style: TextStyle(fontSize: 12, color: Colors.brown),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final int firstIndex = pageIndex * questionsPerPage;
    final int secondIndex = firstIndex + 1;
    final bool hasSecondQuestion = secondIndex < questions.length;

    final int totalPages = (questions.length / questionsPerPage).ceil();
    final bool isLastPage = pageIndex == totalPages - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.brown),
        title: const Text("Assessment", style: TextStyle(color: Colors.brown)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "${pageIndex + 1} of $totalPages",
                style: const TextStyle(color: Colors.brown),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: size.width * 0.9,
            height: size.height * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  "In the last month, how often have you…",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 24),

                // ===== First Question =====
                buildQuestionBlock(firstIndex),

                // ===== Second Question (if exists) =====
                if (hasSecondQuestion) ...[
                  const SizedBox(height: 32),
                  const Divider(thickness: 2),
                  const SizedBox(height: 32),
                  buildQuestionBlock(secondIndex),
                ],

                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4DB6AC),
                          minimumSize: const Size(0, 50),
                          side: const BorderSide(color: Color(0xFF4DB6AC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: prevPage,
                        child: const Text("Back"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4DB6AC),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: nextPage,
                        child: Text(
                          isLastPage ? "Done" : "Next",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
