import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

import '../widgets/t_nav.dart';
import '../widgets/b_nav.dart';
import '../logic/labels.dart';
import '../data/scores.dart';

//change to assetSource for audioplayer
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  late String _selectedMonthKey;

  @override
  void initState() {
    super.initState();
    _selectedMonthKey = DateFormat('yyyy-MM').format(DateTime.now());
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  List<Map<String, int>> get _currentMonthStress =>
      stressScoresByMonth[_selectedMonthKey] ?? [];

  String _monthLabel(String key) {
    final date = DateFormat('yyyy-MM').parse(key);
    return DateFormat('MMMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name!;
    final args = ModalRoute.of(context)?.settings.arguments;
    final int score = args is int ? args : 0;

    final stressLabel = getStressLabel(score);

    // Push score ONCE after navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (score > 0) {
        final today = DateTime.now().day;

        setState(() {
          stressScoresByMonth.putIfAbsent(_selectedMonthKey, () => []);
          stressScoresByMonth[_selectedMonthKey]!.add({
            "day": today,
            "score": score,
          });
        });
      }
    });

    final monthDate = DateFormat('yyyy-MM').parse(_selectedMonthKey);
    final daysInMonth = DateUtils.getDaysInMonth(
      monthDate.year,
      monthDate.month,
    );
    final sortedData = [..._currentMonthStress]
      ..sort((a, b) => a["day"]!.compareTo(b["day"]!));

    final List<FlSpot> spots = sortedData
        .map(
          (entry) =>
              FlSpot(entry["day"]!.toDouble(), entry["score"]!.toDouble()),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: TopNav(leading: const Icon(Icons.read_more_outlined)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9FFE6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      stressLabel,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Score: $score",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: _selectedMonthKey,
                    items: stressScoresByMonth.keys
                        .map(
                          (key) => DropdownMenuItem(
                            value: key,
                            child: Text(_monthLabel(key)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedMonthKey = value;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== Chart =====
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D9FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  height: 220,
                  child: spots.isEmpty
                      ? const Center(
                          child: Text(
                            "No stress data yet 🌱\nComplete a questionnaire!",
                            textAlign: TextAlign.center,
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            minX: 1,
                            maxX: daysInMonth.toDouble(),
                            minY: 0,
                            maxY: 50,
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    final day = value.toInt();

                                    if (day == 1 || day % 3 == 0) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          day.toString(),
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    }

                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),

                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: Colors.brown,
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // ===== Song =====
              const Text(
                "Song of the Day:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D9FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Never Gonna Give You Up",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Rick Astley"),
                        ],
                      ),
                    ),
                    IconButton(
                      iconSize: 42,
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                      ),
                      onPressed: () async {
                        if (isPlaying) {
                          await _player.pause();
                        } else {
                          await _player.play(
                            UrlSource(
                              'assets/music/never_gonna_give_you_up.mp3',
                            ),
                          );
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNav(currentRoute: currentRoute),
      ),
    );
  }
}
