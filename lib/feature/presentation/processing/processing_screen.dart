import 'package:flutter/material.dart';
import 'package:imposter/feature/presentation/result/result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final dynamic targetPlayer;
  const ProcessingScreen({super.key, required this.targetPlayer});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    // 5 soniyadan so'ng natija sahifasiga o'tadi
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(player: widget.targetPlayer)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1723),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("HAQIQAT YUZAGA CHIQMOQDA", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w900, letterSpacing: 5)),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white, strokeWidth: 8),
            const SizedBox(height: 30),
            const Text("Ayg'oqchi fosh qilinmoqda...", style: TextStyle(color: Colors.white70, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}