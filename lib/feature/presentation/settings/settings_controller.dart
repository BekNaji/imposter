import 'package:flutter/material.dart';

class SettingsController {
  // Har bir sozlama uchun alohida ValueNotifier
  final ValueNotifier<int> impostorCount = ValueNotifier<int>(1);
  final ValueNotifier<bool> showHints = ValueNotifier<bool>(true);
  final ValueNotifier<Duration> roundDuration = ValueNotifier<Duration>(const Duration(minutes: 2));

  // Metodlar
  void updateImpostor(int change) {
    int newValue = impostorCount.value + change;
    if (newValue >= 1 && newValue <= 5) {
      impostorCount.value = newValue;
    }
  }

  void toggleHints(bool value) {
    showHints.value = value;
  }

  void updateDuration(int secondsChange) {
    int totalSeconds = roundDuration.value.inSeconds + secondsChange;
    if (totalSeconds >= 30 && totalSeconds <= 600) { // 30s dan 10m gacha
      roundDuration.value = Duration(seconds: totalSeconds);
    }
  }
}