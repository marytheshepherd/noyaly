import 'package:flutter/material.dart';
import '../logic/labels.dart';

class StressArticleScreen extends StatelessWidget {
  final StressLabelInfo info;

  const StressArticleScreen({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.brown,
        title: const Text("Why am I stressed?"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 16),
              _ArticleIntro(info: info),
              const SizedBox(height: 20),
              Text(
                "Why you might feel this way",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                info.whyDescription,
                style: const TextStyle(fontSize: 16, color: Colors.brown),
              ),
              const SizedBox(height: 20),
              Text(
                "Gentle relief ideas",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 8),
              ...info.gentleTips.map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "• ",
                        style: TextStyle(fontSize: 16, color: Colors.brown),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "If this feels heavy, you do not have to carry it alone. A quick check-in with someone you trust can help.",
                  style: TextStyle(fontSize: 14, color: Colors.brown),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleIntro extends StatelessWidget {
  final StressLabelInfo info;

  const _ArticleIntro({required this.info});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth < 520;
        final imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            info.imageAsset,
            width: isNarrow ? double.infinity : 140,
            height: isNarrow ? 160 : 140,
            fit: BoxFit.cover,
          ),
        );

        final textWidget = Expanded(
          child: Text(
            info.summary,
            style: const TextStyle(fontSize: 16, color: Colors.brown),
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget,
              const SizedBox(height: 12),
              Text(
                info.summary,
                style: const TextStyle(fontSize: 16, color: Colors.brown),
              ),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget,
            const SizedBox(width: 16),
            imageWidget,
          ],
        );
      },
    );
  }
}
