class LaborCost {
  final int? id;
  final String name;
  final double hours;
  final double rate;

  LaborCost({
    this.id,
    required this.name,
    required this.hours,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'hours': hours,
      'rate': rate,
    };
  }

  static LaborCost fromMap(Map<String, dynamic> map) {
    return LaborCost(
      id: map['id'],
      name: map['name'],
      hours: map['hours'].toDouble(),
      rate: map['rate'].toDouble(),
    );
  }
}