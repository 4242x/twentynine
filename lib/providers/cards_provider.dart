import 'package:flutter_riverpod/legacy.dart';
import 'package:twentynine/models/card_model.dart';

class CardsNotifier extends StateNotifier<List<CardModel>> {
  CardsNotifier() : super([]);

  void setCards(List cards) {
    state = cards.map((e) {
      if (e is Map<String, dynamic>) {
        return CardModel.fromJson(e);
      } else if (e is Map) {
        return CardModel.fromJson(Map<String, dynamic>.from(e));
      }
      return CardModel(suit: '', rank: '');
    }).toList();
  }

  void clearCards() {
    state = [];
  }
}

final cardsProvider = StateNotifierProvider<CardsNotifier, List<CardModel>>((ref) {
  return CardsNotifier();
});

final dealtCardsProvider = cardsProvider;
