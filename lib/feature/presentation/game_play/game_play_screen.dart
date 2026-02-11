import 'dart:math' as Math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'package:imposter/feature/presentation/game_play/game_play_controller.dart';
import 'package:imposter/feature/presentation/reveal_card/reveal_card_controller.dart';
import 'package:imposter/feature/presentation/vote/vote_screen.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> with SingleTickerProviderStateMixin {
  late final GamePlayController _controller = getIt<GamePlayController>();
  late final RevealCardController _revealController = getIt<RevealCardController>();
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Vaqt tugashini kuzatish uchun listener qo'shamiz
    _controller.remainingTime.addListener(_timeListener);
  }

  // Vaqtni tekshirib turuvchi funksiya
  void _timeListener() {
    if (_controller.remainingTime.value.inSeconds == 0) {
      // Listenerni o'chiramiz (alert bir marta chiqishi uchun)
      _controller.remainingTime.removeListener(_timeListener);
      _showTimeUpDialog();
    }
  }

  // Vaqt tugaganda chiqadigan chiroyli Alert
  void _showTimeUpDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "TimeUp",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              backgroundColor: const Color(0xFF1A1723),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.alarm_on, color: Colors.white, size: 80),
                  const SizedBox(height: 20),
                  const Text(
                    "VAQT TUGADI!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Munozara tugadi. Endi ayg'oqchini fosh qilish vaqti keldi!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Alertni yopish
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VotingScreen(players: _revealController.players),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "OVOZ BERISH",
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // Memory leak bo'lmasligi uchun listener va controllerlarni tozalaymiz
    _controller.remainingTime.removeListener(_timeListener);
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE94444),
      body: Stack(
        children: [
          // 1. Animatsiyali To'lqinli Fon
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return ValueListenableBuilder<Duration>(
                valueListenable: _controller.remainingTime,
                builder: (context, time, _) {
                  return ClipPath(
                    clipper: AnimatedWaveClipper(_waveController.value * 2 * Math.pi),
                    child: Container(
                      height: MediaQuery.of(context).size.height * _controller.progress,
                      width: double.infinity,
                      color: const Color(0xFF1A1723),
                    ),
                  );
                },
              );
            },
          ),

          // 2. UI Elementlari
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                const Text(
                  "Vaqt",
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                ValueListenableBuilder<Duration>(
                  valueListenable: _controller.remainingTime,
                  builder: (context, time, _) {
                    return Text(
                      _formatDuration(time),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    );
                  },
                ),
                const Spacer(),
                _buildDynamicButtons(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicButtons() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.isPaused,
      builder: (context, paused, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: paused ? _buildPausedStateButtons() : _buildActiveStateButton(),
        );
      },
    );
  }

  Widget _buildActiveStateButton() {
    return Padding(
      key: const ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: _customButton(
        text: "To'xtatish",
        onTap: _controller.togglePause,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPausedStateButtons() {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: _customButton(
              text: "Davom etish",
              onTap: _controller.togglePause,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _customButton(
              text: "Ovoz berish",
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VotingScreen(players: _revealController.players)),
                );
              },
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customButton({required String text, required VoidCallback onTap, required Color color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Center(
          child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black)),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}

class AnimatedWaveClipper extends CustomClipper<Path> {
  final double wavePhase;
  AnimatedWaveClipper(this.wavePhase);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 25);
    for (double x = 0; x <= size.width; x++) {
      double y = Math.sin((x / size.width * 2 * Math.pi) + wavePhase) * 15;
      path.lineTo(x, size.height - 35 + y);
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(AnimatedWaveClipper oldClipper) => oldClipper.wavePhase != wavePhase;
}