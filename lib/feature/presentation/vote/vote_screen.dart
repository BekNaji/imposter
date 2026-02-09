import 'package:flutter/material.dart';
import 'package:imposter/feature/presentation/processing/processing_screen.dart';

class VotingScreen extends StatefulWidget {
  final List<dynamic> players; // Sizning GamePlayer ro'yxatingiz
  const VotingScreen({super.key, required this.players});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? selectedIndex; // Tanlangan o'yinchi indeksi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1723),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text("Impostor kim?", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                const Text("Shubhalanayotgan o'yinchingizni tanlang", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: _getCardColor(index),
                            borderRadius: BorderRadius.circular(25),
                            border: isSelected ? Border.all(color: Colors.white, width: 5) : null,
                            boxShadow: isSelected ? [BoxShadow(color: Colors.white.withOpacity(0.3), blurRadius: 15)] : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Image.asset("assets/images/avatar-${(index % 3) + 1}.png", fit: BoxFit.contain)),
                              Text(widget.players[index].name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100), // Tugma uchun joy
              ],
            ),
          ),

          // Oylarni yuborish tugmasi
          if (selectedIndex != null)
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProcessingScreen(targetPlayer: widget.players[selectedIndex!])),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                ),
                child: const Text("OYLARI GÖNDER", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCardColor(int index) {
    List<Color> colors = [const Color(0xFFE35622), const Color(0xFF62BD32), const Color(0xFF4A90E2), const Color(0xFFF5A623)];
    return colors[index % colors.length];
  }
}