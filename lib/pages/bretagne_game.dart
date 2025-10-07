import 'dart:async';
import 'package:flutter/material.dart';

class BretagneGamePage extends StatefulWidget {
  const BretagneGamePage({super.key});

  @override
  State<BretagneGamePage> createState() => _BretagneGamePageState();
}

class _BretagneGamePageState extends State<BretagneGamePage> {
  static const int totalTimeInMinutes = 45;
  late Duration remainingTime;
  Timer? _timer;
  bool isRunning = true;

  @override
  void initState() {
    super.initState();
    remainingTime = Duration(minutes: totalTimeInMinutes);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        // TODO : fin du jeu
      }
    });
  }

  void _toggleTimer() {
    setState(() {
      if (isRunning) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
      isRunning = !isRunning;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/parchemin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(Icons.menu, size: 28),
                      onPressed: () {
                      },
                    ),
                  ),
                ),

                const Spacer(),

                Text(
                  _formatTime(remainingTime),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),

                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _toggleTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    isRunning ? 'STOP' : 'REPRENDRE',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const Spacer(),

                // Bouton inventaire (en bas)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Pas encore relié
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade300,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "INVENTAIRE",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}