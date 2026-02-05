import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../widgets/b_nav.dart';
import '../widgets/t_nav.dart';
import '../logic/labels.dart';
import 'report_label.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Not logged in")));
    }

    final monthStart = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final monthEnd = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F3EE),
      appBar: TopNav(leading: const Icon(Icons.read_more_outlined)),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .collection("stress_entries")
              .where(
                "createdAt",
                isGreaterThanOrEqualTo: Timestamp.fromDate(monthStart),
              )
              .where("createdAt", isLessThan: Timestamp.fromDate(monthEnd))
              .orderBy("createdAt")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;

            final spots = docs.map((doc) {
              final dateStr = doc["date"];
              final day = DateTime.parse(dateStr).day;
              final score = doc["score"];
              return FlSpot(day.toDouble(), score.toDouble());
            }).toList()..sort((a, b) => a.x.compareTo(b.x));

            final latestDoc = docs.isNotEmpty ? docs.last : null;
            final int score = latestDoc != null
                ? (latestDoc["score"] as num).toInt()
                : 0;
            final Map<String, dynamic>? latestData =
                latestDoc?.data() as Map<String, dynamic>?;
            final String? labelKey = latestData?["labelKey"] as String?;
            final String? labelText = latestData?["labelText"] as String?;
            final labelInfo = labelKey != null
                ? getStressLabelInfo(labelKey)
                : getStressLabelInfoFromScore(score);
            final stressLabel = labelText ?? labelInfo.shortLabel;

            final daysInMonth = DateUtils.getDaysInMonth(
              _selectedMonth.year,
              _selectedMonth.month,
            );

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Material(
                    color: const Color(0xFFD9FFE6),
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                StressArticleScreen(info: labelInfo),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
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
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month - 1,
                            );
                          });
                        },
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedMonth),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          setState(() {
                            _selectedMonth = DateTime(
                              _selectedMonth.year,
                              _selectedMonth.month + 1,
                            );
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 420,
                      child: spots.isEmpty
                          ? const Center(
                              child: Text(
                                "No stress data for this month",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.brown,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : LineChart(
                              LineChartData(
                                minX: 1,
                                maxX: daysInMonth.toDouble(),
                                minY: 0,
                                maxY: 100,
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(
                                  show: true,
                                  border: const Border(
                                    bottom: BorderSide(color: Colors.grey),
                                    left: BorderSide(color: Colors.grey),
                                    right: BorderSide.none,
                                    top: BorderSide.none,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    axisNameWidget: const Text("Stress Level"),
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    axisNameWidget: const Text("Days"),
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 5,
                                      reservedSize: 28,
                                    ),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    barWidth: 2,
                                    color: const Color(0xFF4DB6AC),
                                    dotData: FlDotData(show: true),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(child: BottomNav(currentRoute: "/report")),
    );
  }
}
