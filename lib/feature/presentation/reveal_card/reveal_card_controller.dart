import 'dart:math';
import 'package:flutter/foundation.dart';

enum PlayerRole { civilian, imposter }

class GamePlayer {
  final String name;
  PlayerRole role;
  final String secretWord;

  GamePlayer({required this.name, required this.role, required this.secretWord});
}

class RevealCardController {
  final List<GamePlayer> players = [];

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  final ValueNotifier<double> revealAmount = ValueNotifier<double>(0.0);

  final ValueNotifier<bool> hasSeenSecret = ValueNotifier<bool>(false);

  final isLastPlayer = ValueNotifier<bool>(false);


  void setupGame(List<String> names, int imposterCount, String secretWord) {
    if (names.isEmpty) {
      debugPrint("Xato: O'yinchilar ro'yxati bo'sh!");
      return;
    }

    players.clear();
    currentIndex.value = 0;
    hasSeenSecret.value = false;

    List<GamePlayer> tempPlayers = names.map((name) =>
        GamePlayer(name: name, role: PlayerRole.civilian, secretWord: secretWord)
    ).toList();

    final random = Random();
    int assigned = 0;
    while (assigned < imposterCount) {
      int idx = random.nextInt(tempPlayers.length);
      if (tempPlayers[idx].role == PlayerRole.civilian) {
        tempPlayers[idx].role = PlayerRole.imposter;
        assigned++;
      }
    }
    players.addAll(tempPlayers);
  }

  void updateReveal(double delta, double screenHeight) {
    double newValue = revealAmount.value - (delta / screenHeight);
    revealAmount.value = newValue.clamp(0.0, 0.5);

    if (revealAmount.value > 0.4) {
      hasSeenSecret.value = true;
    }
  }

  void finalizeReveal() {
    if (revealAmount.value < 0.3) {
      revealAmount.value = 0.0;
    } else {
      revealAmount.value = 0.5;
    }
  }

  bool nextPlayer() {
    isLastPlayer.value = (currentIndex.value == (players.length - 2));
    if (currentIndex.value < players.length - 1) {
      currentIndex.value++;
      revealAmount.value = 0.0;
      hasSeenSecret.value = false;
      return true;
    }
    return false;
  }

  GamePlayer? get currentPlayer {
    if (players.isEmpty) return null; // Agar bo'sh bo'lsa, null qaytaradi
    return players[currentIndex.value];
  }
  bool get isClosed => revealAmount.value == 0.0;
}