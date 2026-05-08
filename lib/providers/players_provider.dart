import 'package:flutter_riverpod/legacy.dart';

class PlayersNotifier extends StateNotifier<List<String>> {
  PlayersNotifier() : super([]);
  void updatePlayers(List players){
    state = players.map((e) => e.toString()).toList();
  }
}
final playersProvider = StateNotifierProvider<PlayersNotifier, List<String>>((ref){
  return PlayersNotifier();
});