import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerController {
  // O'yinchilar ro'yxati uchun ValueNotifier
  final ValueNotifier<List<String>> playersNotifier = ValueNotifier<List<String>>([]);

  static const String _storageKey = 'saved_players';

  PlayerController() {
    _loadPlayers();
  }

  // Storagedan o'yinchilarni o'qish
  Future<void> _loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedPlayers = prefs.getStringList(_storageKey);
    if (savedPlayers != null) {
      playersNotifier.value = savedPlayers;
    }
  }

  // Storagga saqlash
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, playersNotifier.value);
  }

  // O'yinchi qo'shish
  void addPlayer(String name) {
    if (name.trim().isNotEmpty) {
      playersNotifier.value = [...playersNotifier.value, name.trim()];
      _saveToStorage();
    }
  }

  // O'yinchini o'chirish
  void removePlayer(int index) {
    List<String> newList = List.from(playersNotifier.value);
    newList.removeAt(index);
    playersNotifier.value = newList;
    _saveToStorage();
  }

  // O'yinchini tahrirlash
  void editPlayer(int index, String newName) {
    if (newName.trim().isNotEmpty) {
      List<String> newList = List.from(playersNotifier.value);
      newList[index] = newName.trim();
      playersNotifier.value = newList;
      _saveToStorage();
    }
  }
}

