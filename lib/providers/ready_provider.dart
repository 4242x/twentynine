import 'package:flutter_riverpod/legacy.dart';

class ReadyNotifier extends StateNotifier<bool> {
  ReadyNotifier() : super(false);
  void readyState(bool a) {
    state = a;
  }
}

final readyProvider = StateNotifierProvider<ReadyNotifier, bool>((ref) {
  return ReadyNotifier();
});
