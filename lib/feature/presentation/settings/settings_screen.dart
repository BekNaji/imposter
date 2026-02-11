import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'package:imposter/core/widgets/app_scaffold.dart';
import 'package:imposter/feature/presentation/player/player_controller.dart';
import 'package:imposter/feature/presentation/reveal_card/reveal_card_screen.dart';
import 'settings_controller.dart'; // Siz yaratgan controller

class SettingsScreen extends StatelessWidget {
  final SettingsController _controller = getIt<SettingsController>();
  final PlayerController _playerController = getIt<PlayerController>();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: _buildHeader(context),
      bottom: ValueListenableBuilder<int>(
        valueListenable: _controller.impostorCount,
        builder: (context, count, _) => _buildBottomButton(context, count),
      ),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ValueListenableBuilder<int>(
            valueListenable: _controller.impostorCount,
            builder: (context, count, _) {
              return _buildSettingCard(
                title: "Ayg'oqchilar",
                subtitle: "Nechta o'yinchi maxfiy ayg'oqchi bo'lsin ?",
                footer: "${_playerController.playersNotifier.value.length} o'yinchi uchun tavsiya etiladi: 1",
                content: _buildCounter(
                  value: count.toString(),
                  onMinus: () => _controller.updateImpostor(-1),
                  onPlus: () => _controller.updateImpostor(1),
                ),
              );
            },
          ),

          // 2. Ipuçları (Switcher)
          // ValueListenableBuilder<bool>(
          //   valueListenable: _controller.showHints,
          //   builder: (context, isEnabled, _) {
          //     return _buildSettingCard(
          //       title: "Ayg'oqchilar uchun ishora so'z",
          //       subtitle: "Ayg'oqchilarga maxfiy so'z bo'yicha ishora berilsinmi ?",
          //       content: _buildSwitcher(
          //         isActive: isEnabled,
          //         onToggle: _controller.toggleHints,
          //       ),
          //     );
          //   },
          // ),

          // 3. Tur vaqti
          ValueListenableBuilder<Duration>(
            valueListenable: _controller.roundDuration,
            builder: (context, duration, _) {
              return _buildSettingCard(
                title: "O'yin vaqti",
                subtitle: "Har bir bahs raundi qancha davom etsin?",
                content: _buildCounter(
                  value: _formatDuration(duration),
                  onMinus: () => _controller.updateDuration(-15),
                  onPlus: () => _controller.updateDuration(15),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- UI Komponentlar ---

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "O'yin sozlamalari",
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 48), // Balans uchun
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget content,
    String? footer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF252131),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          if (footer != null) ...[
            const SizedBox(height: 4),
            Text(footer, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
          const SizedBox(height: 25),
          content,
        ],
      ),
    );
  }

  Widget _buildCounter({required String value, required VoidCallback onMinus, required VoidCallback onPlus}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleBtn(Icons.remove, onMinus),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        _circleBtn(Icons.add, onPlus),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildSwitcher({required bool isActive, required Function(bool) onToggle}) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(child: _switchOption("Yopiq", !isActive, () => onToggle(false))),
          Expanded(child: _switchOption("Ochiq", isActive, () => onToggle(true))),
        ],
      ),
    );
  }

  Widget _switchOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? const Color(0xFF252131) : Colors.white60,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString();
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildBottomButton(context, int count) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RevealCardScreen()));
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "BOSHLASH",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF252131)),
            ),
            Container(
              height: 30,
              width: 2,
              color: Colors.black12,
              margin: const EdgeInsets.symmetric(horizontal: 15),
            ),
            Text(
              "$count ayg'occhi",
              style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}