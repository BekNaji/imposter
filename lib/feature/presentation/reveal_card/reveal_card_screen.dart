import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'package:imposter/core/widgets/app_scaffold.dart';
import 'package:imposter/feature/presentation/cateogory/category_controller.dart';
import 'package:imposter/feature/presentation/game_play/game_play_controller.dart';
import 'package:imposter/feature/presentation/game_play/game_play_screen.dart';
import 'package:imposter/feature/presentation/reveal_card/reveal_card_controller.dart';
import 'package:imposter/feature/presentation/player/player_controller.dart';
import 'package:imposter/feature/presentation/settings/settings_controller.dart';

class RevealCardScreen extends StatefulWidget {
  const RevealCardScreen({super.key});

  @override
  State<RevealCardScreen> createState() => _RevealCardScreenState();
}

class _RevealCardScreenState extends State<RevealCardScreen> {
  final RevealCardController _controller = getIt<RevealCardController>();
  final PlayerController _playerController = getIt<PlayerController>();
  final SettingsController _settingsController = getIt<SettingsController>();
  final CategoryController _categoryController = getIt<CategoryController>();

  final List<Color> _playerColors = [
    const Color(0xFF4CAF50), // Yashil
    const Color(0xFFE35622), // To'q sariq
    const Color(0xFF4A90E2), // Moviy
    const Color(0xFFF5A623), // Sariq
    const Color(0xFF9C27B0), // Binafsha
  ];

  @override
  void initState() {
    super.initState();
    _controller.setupGame(_playerController.playersNotifier.value.toList(), _settingsController.impostorCount.value, _categoryController.getRandomWord());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: _controller.currentIndex,
            builder: (context, index, _) {
              return _buildSecretLayer();
            },
          ),

          ValueListenableBuilder<double>(
            valueListenable: _controller.revealAmount,
            builder: (context, reveal, _) {
              return _buildDraggableCover(context, reveal);
            },
          ),
          _buildActionForward(),
        ],
      ),
    );
  }

  Widget _buildSecretLayer() {
    final player = _controller.currentPlayer;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              player?.role == PlayerRole.imposter ? "SIZ AYG'OQCHISIZ" : player?.secretWord ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableCover(BuildContext context, double reveal) {
    return GestureDetector(
      onVerticalDragUpdate: (d) => _controller.updateReveal(d.primaryDelta!, MediaQuery.of(context).size.height),
      onVerticalDragEnd: (d) => _controller.finalizeReveal(),
      child: ValueListenableBuilder<int>(
        valueListenable: _controller.currentIndex,
        builder: (context, index, _) {
          // Rangni index bo'yicha tanlaymiz, agar o'yinchilar ko'p bo'lsa ro'yxat takrorlanadi
          final backgroundColor = _playerColors[index % _playerColors.length];

          return Transform.translate(
            offset: Offset(0, -reveal * MediaQuery.of(context).size.height),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: backgroundColor, // RANG SHU YERDA O'ZGARADI
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                        ),
                      ],
                    ),
                    Text(
                      _controller.currentPlayer?.name ?? "",
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    const Spacer(),
                    // Rasm o'zgarishi (sizda allaqachon bor)
                    Image.asset("assets/images/avatar-${index + 1}.png", height: 350),
                    const Spacer(),
                    ValueListenableBuilder<bool>(
                      valueListenable: _controller.hasSeenSecret,
                      builder: (context, seen, _) {
                        if (seen) return const SizedBox(height: 30);
                        return const Column(
                          children: [
                            ScrollingHint(),
                            SizedBox(height: 30),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionForward() {
    return ValueListenableBuilder<bool>(
      valueListenable: _controller.hasSeenSecret,
      builder: (context, seen, _) {
        return ValueListenableBuilder<double>(
          valueListenable: _controller.revealAmount,
          builder: (context, reveal, _) {
            if (seen && reveal == 0.0) {
              return Positioned(
                bottom: 60,
                left: 30,
                right: 30,
                child: ElevatedButton(
                  onPressed: () {
                    bool hasNext = _controller.nextPlayer();
                    if (!hasNext) {
                      late final GamePlayController controller = getIt<GamePlayController>();
                      late final SettingsController settingsController = getIt<SettingsController>();
                      controller.startTimer(totalDuration: settingsController.roundDuration.value);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GamePlayScreen()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 65),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: _controller.isLastPlayer,
                    builder: (context, isLastPlayer, _) {
                      return Text(
                        isLastPlayer ? "BOSHLASH" : "DAVOM ETISH",
                        style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900),
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class ScrollingHint extends StatefulWidget {
  const ScrollingHint({super.key});

  @override
  State<ScrollingHint> createState() => _ScrollingHintState();
}

class _ScrollingHintState extends State<ScrollingHint> with SingleTickerProviderStateMixin {
  late final AnimationController _hintController;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true); // Borib-kelib turishi uchun

    _offsetAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_offsetAnimation.value), // Yuqoriga siljish
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.keyboard_arrow_up, size: 40, color: Colors.white),
              const SizedBox(height: 5),
              const Text(
                "Maxfiy so'zni ko'rish uchun\ntepaga skroll qiling",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
