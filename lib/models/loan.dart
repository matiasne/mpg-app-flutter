import 'package:mpg_mobile/models/business_valuation.dart';

class Loan {
  int? id;
  int numberOfYears;
  double amount;
  double downPayment;
  double loanAmount;
  DateTime startDate;
  BusinessValuation? businessValuation;

  Loan({
    this.id,
    required this.numberOfYears,
    required this.amount,
    required this.downPayment,
    required this.loanAmount,
    required this.startDate,
    this.businessValuation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numberOfYears': numberOfYears,
      'amount': amount,
      'downPayment': downPayment,
      'loanAmount': loanAmount,
      'startDate': startDate.toIso8601String(),
      'businessValuation': businessValuation?.toMap(),
    };
  }

  static Loan? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return Loan(
      id: map['id'],
      numberOfYears: map['numberOfYears'],
      amount: (map['amount'] as num).toDouble(),
      downPayment: (map['downPayment'] as num).toDouble(),
      loanAmount: (map['loanAmount'] as num).toDouble(),
      startDate: DateTime.parse(map['startDate']),
      businessValuation: map['businessValuation'] == null
          ? null
          : BusinessValuation.fromMap(map['businessValuation']),
    );
  }
}
