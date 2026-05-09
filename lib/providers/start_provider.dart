import 'package:flutter_riverpod/legacy.dart';

class StartNotifier extends StateNotifier<bool>{
  StartNotifier() : super(false);
  void startState(bool a){
    state = a;
  }
}
final startProvider = StateNotifierProvider<StartNotifier , bool>((ref){
  return StartNotifier();
}
);