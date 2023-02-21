class AccountReceivable {
  String description;
  DateTime date;
  double amount;

  AccountReceivable(
      {required this.description,
      required this.date,
      required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'date': date.toIso8601String(),
      'amount': amount,
    };
  }

  static AccountReceivable fromMap(Map<String, dynamic> map) {
    return AccountReceivable(
      description: map['description'],
      date: DateTime.parse(map['date']),
      amount: (map['amount'] as num).toDouble(),
    );
  }
}
