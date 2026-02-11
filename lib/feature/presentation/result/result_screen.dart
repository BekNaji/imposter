import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final dynamic player;
  const ResultScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    // PlayerRole enumiga qarab tekshiramiz
    final bool isImposterFound = player.role.toString().contains('imposter');

    return Scaffold(
      backgroundColor: isImposterFound ? const Color(0xFF4CAF50) : const Color(0xFFE94444),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("Natijalar", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: const Color(0xFF252131), borderRadius: BorderRadius.circular(40)),
              child: Column(
                children: [
                  Text(isImposterFound ? "O'yinchilar\ng'alaba qozondi!" : "Ayg'oqchi\ng'alaba qozondi!",
                      textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text(isImposterFound ? "Ayg'oqchi topildi" : "Ayg'oqchi qochib ketdi", style: const TextStyle(color: Colors.white54, fontSize: 16)),
                  const SizedBox(height: 30),
                  // Tanlangan o'yinchi rasmi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset("assets/images/avatar-1.png", height: 150),
                  ),
                  const SizedBox(height: 10),
                  Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            _buildInfoCard("Maxfiy so'z", player.secretWord),
            const Spacer(),
            _buildActionButtons(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 65),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        ),
        child: const Text("QAYTA O'YNASH ↻", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900)),
      ),
    );
  }
}