
import 'package:get_it/get_it.dart';
import 'package:imposter/feature/presentation/cateogory/category_controller.dart';
import 'package:imposter/feature/presentation/game_play/game_play_controller.dart';
import 'package:imposter/feature/presentation/reveal_card/reveal_card_controller.dart';
import 'package:imposter/feature/presentation/player/player_controller.dart';
import 'package:imposter/feature/presentation/settings/settings_controller.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async{
  getIt.registerSingleton<CategoryController>(CategoryController());
  getIt.registerSingleton<SettingsController>(SettingsController());
  getIt.registerSingleton<PlayerController>(PlayerController());
  getIt.registerSingleton<RevealCardController>(RevealCardController());
  getIt.registerSingleton<GamePlayController>(GamePlayController());
}