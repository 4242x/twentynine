class CardModel {
  final String suit;
  final String rank;

  const CardModel({
    required this.suit,
    required this.rank,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      suit: json['suit']?.toString() ?? '',
      rank: json['rank']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'suit': suit,
      'rank': rank,
    };
  }

  @override
  String toString() => '$rank of $suit';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardModel &&
          runtimeType == other.runtimeType &&
          suit == other.suit &&
          rank == other.rank;

  @override
  int get hashCode => suit.hashCode ^ rank.hashCode;
}
