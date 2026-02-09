import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'feature/presentation/player/player_screen.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imposter Tahmin qil',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const PlayersScreen(),
    );
  }
}



