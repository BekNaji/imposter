import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'package:imposter/feature/presentation/game_play/game_play_controller.dart';
import 'package:imposter/feature/presentation/player/player_controller.dart';
import 'package:imposter/feature/presentation/reveal_card/reveal_card_controller.dart';
import 'package:imposter/feature/presentation/vote/vote_screen.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> with SingleTickerProviderStateMixin {
  // Controllerlarni getIt orqali olamiz
  late final GamePlayController _controller = getIt<GamePlayController>();
  late final RevealCardController _revealController = getIt<RevealCardController>();
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    // To'lqinning doimiy harakati uchun controller
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    // Controllerlarni tozalash (Memory leak oldini olish)
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE94444), // Pastki qizil fon
      body: Stack(
        children: [
          // 1. Animatsiyali To'lqinli Fon (Qora qism)
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return ValueListenableBuilder<Duration>(
                valueListenable: _controller.remainingTime,
                builder: (context, time, _) {
                  return ClipPath(
                    clipper: AnimatedWaveClipper(_waveController.value * 2 * Math.pi),
                    child: Container(
                      // Vaqtga qarab balandlik silliq o'zgaradi
                      height: MediaQuery.of(context).size.height * _controller.progress,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1A1723), // To'q qora fon
                      ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                // Katta Taymer
                ValueListenableBuilder<Duration>(
                  valueListenable: _controller.remainingTime,
                  builder: (context, time, _) {
                    return Text(
                      _formatDuration(time),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 100,
                        fontWeight: FontWeight.w900,
                        fontFeatures: [FontFeature.tabularFigures()], // Raqamlar qimirlamasligi uchun
                      ),
                    );
                  },
                ),
                const Spacer(),
                // Dinamik Tugmalar
                _buildDynamicButtons(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Yuqori qism (Back va Info)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
          ),
          IconButton(
            onPressed: () {
              // O'yin qoidalari haqida ma'lumot
            },
            icon: const Icon(Icons.info_outline, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  // Pauza holatiga qarab o'zgaruvchi tugmalar
  Widget _buildDynamicButtons() {
    return ValueListenableBuilder<bool>(
        valueListenable: _controller.isPaused,
        builder: (context, paused, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300), // Tugmalar almashinuvi uchun animatsiya
            child: paused
                ? _buildPausedStateButtons()
                : _buildActiveStateButton(),
          );
        }
    );
  }

  // Faol holatdagi tugma (To'xtatish)
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

  // To'xtatilgan holatdagi tugmalar (Ovoz berish va Davom etish)
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
               Navigator.push(context, MaterialPageRoute(builder: (context) => VotingScreen(players: _revealController.players)));
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.black
            ),
          ),
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

// To'lqinni chizuvchi Clipper
class AnimatedWaveClipper extends CustomClipper<Path> {
  final double wavePhase;

  AnimatedWaveClipper(this.wavePhase);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 25);

    for (double x = 0; x <= size.width; x++) {
      // Sinusoida orqali to'lqin yasash
      double y = Math.sin((x / size.width * 2 * Math.pi) + wavePhase) * 15;
      path.lineTo(x, size.height - 35 + y);
    }

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(AnimatedWaveClipper oldClipper) =>
      oldClipper.wavePhase != wavePhase;
}