class FinanctialIndicator {
  String name;
  int year;
  double amount;
  double projectedGrowth;

  FinanctialIndicator({
    required this.name,
    required this.year,
    required this.amount,
    required this.projectedGrowth,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'year': year,
      'amount': amount,
      'projectedGrowth': projectedGrowth,
    };
  }

  static FinanctialIndicator fromMap(Map<String, dynamic> map) {
    return FinanctialIndicator(
      name: map['name'],
      year: map['year'],
      amount: (map['amount'] as num).toDouble(),
      projectedGrowth: (map['projectedGrowth'] as num).toDouble(),
    );
  }
}
