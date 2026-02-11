import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'package:imposter/core/widgets/app_scaffold.dart';
import 'package:imposter/feature/presentation/cateogory/category_screen.dart';
import 'package:imposter/feature/presentation/player/player_controller.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({super.key});

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final PlayerController _controller = getIt<PlayerController>();
  final TextEditingController _addController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: _buildHeader(),
      bottom: _buildBottomButton(),
      child: ValueListenableBuilder<List<String>>(
        valueListenable: _controller.playersNotifier,
        builder: (context, players, child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: players.length + 1,
            itemBuilder: (context, index) {
              if (index < players.length) {
                return _buildPlayerTile(index, players[index]);
              } else {
                return _buildAddPlayerField();
              }
            },
          );
        },
      ),
    );
  }

  // O'yinchi qatori
  Widget _buildPlayerTile(int index, String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 25, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(color: const Color(0xFF252131), borderRadius: BorderRadius.circular(40)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
              decoration: const InputDecoration(border: InputBorder.none),
              controller: TextEditingController(text: name),
              onSubmitted: (val) => _controller.editPlayer(index, val),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => _controller.removePlayer(index),
          ),
        ],
      ),
    );
  }

  // Yangi o'yinchi kiritish
  Widget _buildAddPlayerField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(color: const Color(0xFF252131), borderRadius: BorderRadius.circular(40)),
            child: TextField(
              controller: _addController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "O'yinchi ismini kiriting",
                hintStyle: TextStyle(color: Colors.white38),
                border: InputBorder.none,
              ),
              onSubmitted: (val) {
                _controller.addPlayer(val);
                _addController.clear();
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            _controller.addPlayer(_addController.text);
            _addController.clear();
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: Color(0xFF252131), shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _controller.playersNotifier,
      builder: (context, players, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Davom etish",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF252131)),
                ),
                Container(height: 30, width: 2, color: Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 15)),
                Text(
                  "${players.length} o'yinchi",
                  style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 40),
          const Text(
            "O'yinchilar",
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.settings, color: Colors.white, size: 30),
          // ),
        ],
      ),
    );
  }
}
