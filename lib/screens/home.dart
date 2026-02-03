import 'package:flutter/material.dart';
import 'package:noyaly/widgets/t_nav.dart';
import '../widgets/b_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: TopNav(leading: Icon(Icons.home_outlined)),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Divider(thickness: 2),

            Expanded(
              child: Center(
                child: Container(
                  width: size.width * 0.9,
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFA7D7B9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Image.asset(
                                'assets/logo/eye.png',
                                width: size.width * 0.28,
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "how",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                  Text(
                                    "STRESSED",
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFFE85D5D),
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  Text(
                                    "are you?",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: size.width * 0.65,
                        height: 120,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final buttonWidth = constraints.maxWidth;
                            final cloudSize = buttonWidth * 0.22;

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: SizedBox(
                                    width: buttonWidth,
                                    child: FilledButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/question',
                                        );
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Color(0xFF4DB6AC),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 28,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Click here to\nfind out!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: buttonWidth * 0.01,
                                  top: -cloudSize * 0.35,
                                  child: Transform.rotate(
                                    angle: -0.12,
                                    child: Image.asset(
                                      'assets/logo/noyaly.png',
                                      width: cloudSize * 2,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Streaks:",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            "6",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 28,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(child: BottomNav(currentRoute: "/home")),
    );
  }
}
