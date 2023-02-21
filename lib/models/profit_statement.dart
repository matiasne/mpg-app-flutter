class ProfitStatement {
  String name;
  double current;
  double projected;

  ProfitStatement({
    required this.name,
    required this.current,
    required this.projected,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'current': current,
      'projected': projected,
    };
  }

  static ProfitStatement fromMap(Map<String, dynamic> map) {
    return ProfitStatement(
      name: map['name'],
      current: (map['current'] as num).toDouble(),
      projected:( map['projected'] as num).toDouble(),
    );
  }
}