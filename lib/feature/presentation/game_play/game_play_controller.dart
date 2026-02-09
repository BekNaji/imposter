import 'dart:async';
import 'package:flutter/material.dart';

class GamePlayController {
  late Duration totalDuration;
  late ValueNotifier<Duration> remainingTime;
  late ValueNotifier<bool> isPaused;

  Timer? _timer;


  void startTimer({required Duration totalDuration}) {
    this.totalDuration = totalDuration;
    remainingTime = ValueNotifier<Duration>(totalDuration);
    isPaused = ValueNotifier<bool>(false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused.value) {
        if (remainingTime.value.inSeconds > 0) {
          remainingTime.value -= const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      }
    });
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
  }

  double get progress => remainingTime.value.inSeconds / totalDuration.inSeconds;

  void dispose() {
    _timer?.cancel();
  }
}