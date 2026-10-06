import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twentynine/models/card_model.dart';
import 'package:twentynine/providers/cards_provider.dart';

void main() {
  group('cardsProvider', () {
    test('initial state is empty list', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(cardsProvider), isEmpty);
    });

    test('updates state with dealt cards', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockCardsData = [
        {'suit': 'Heart', 'rank': 'J'},
        {'suit': 'Spade', 'rank': '9'},
      ];

      container.read(cardsProvider.notifier).setCards(mockCardsData);

      final cards = container.read(cardsProvider);
      expect(cards.length, 2);
      expect(cards[0], const CardModel(suit: 'Heart', rank: 'J'));
      expect(cards[1], const CardModel(suit: 'Spade', rank: '9'));
    });

    test('clears cards', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(cardsProvider.notifier).setCards([
        {'suit': 'Heart', 'rank': 'J'},
      ]);
      expect(container.read(cardsProvider).length, 1);

      container.read(cardsProvider.notifier).clearCards();
      expect(container.read(cardsProvider), isEmpty);
    });
  });
}
