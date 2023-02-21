class NonFinanctialIndicator {
  String name;
  int weight;
  int ranking;

  NonFinanctialIndicator({
    required this.name,
    required this.weight,
    required this.ranking,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'weight': weight,
      'ranking': ranking,
    };
  }

  static NonFinanctialIndicator fromMap(Map<String, dynamic> map) {
    return NonFinanctialIndicator(
      name: map['name'],
      weight: map['weight'],
      ranking: map['ranking'],
    );
  }
}