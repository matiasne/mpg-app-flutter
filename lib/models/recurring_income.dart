class RecurringIncome {
  String description;
  String freq;
  int periodNumber;
  DateTime date;
  double amount;

  RecurringIncome(
      {required this.description,
      required this.freq,
      required this.periodNumber,
      required this.date,
      required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'freq': freq,
      'periodNumber': periodNumber,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }

  static RecurringIncome fromMap(Map<String, dynamic> map) {
    return RecurringIncome(
      description: map['description'],
      freq: map['freq'],
      periodNumber: map['periodNumber'],
      date: DateTime.parse(map['date']),
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
