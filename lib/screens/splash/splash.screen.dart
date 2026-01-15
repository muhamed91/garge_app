import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garage_app/tabs/main.tabs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        progress += 0.15;
      });

      if (progress >= 1) {
        timer.cancel();
        _goNext();
      }
    });
  }

  void _goNext() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainTabs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),

            // 🔹 LOGO
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.directions_car,
                size: 42,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 TITLE
            const Text(
              "WerkstattPro",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            // 🔹 SUBTITLE
            Text(
              "Workshop Management, Simplified.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const Spacer(flex: 2),

            // 🔹 PROGRESS BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 LOADING TEXT
            Text(
              "Laden...",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
