import 'package:mpg_mobile/models/financtial_indicator.dart';
import 'package:mpg_mobile/models/non_financtial_indicator.dart';
import 'package:mpg_mobile/models/profit_statement.dart';

import 'loan.dart';

class BusinessValuation {
  int? id;
  String businessName;
  List<FinanctialIndicator> financtialIndicators;
  List<ProfitStatement> profitStatements;
  List<NonFinanctialIndicator> nonFinanctialIndicators;
  Loan? loan;
  double cogs;
  int? userId;

  BusinessValuation(
      {this.id,
      required this.businessName,
      required this.financtialIndicators,
      required this.profitStatements,
      required this.nonFinanctialIndicators,
      required this.cogs,
      this.loan,
      this.userId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'businessName': businessName,
      'financtialIndicators':
          financtialIndicators.map((fi) => fi.toMap()).toList(),
      'profitStatements': profitStatements.map((fi) => fi.toMap()).toList(),
      'nonFinanctialIndicators':
          nonFinanctialIndicators.map((fi) => fi.toMap()).toList(),
      'loan': loan?.toMap(),
      'userId': userId,
      'cogs': cogs,
    };
  }

  static BusinessValuation fromMap(Map<String, dynamic> map) {
    return BusinessValuation(
      id: map['id'],
      businessName: map['businessName'],
      cogs: (map['cogs'] as num).toDouble(),
      financtialIndicators: map['financtialIndicators'] == null
          ? []
          : (List.from(map['financtialIndicators']))
              .map((e) => FinanctialIndicator.fromMap(e))
              .toList(),
      profitStatements: map['profitStatements'] == null
          ? []
          : (List.from(map['profitStatements']))
              .map((e) => ProfitStatement.fromMap(e))
              .toList(),
      nonFinanctialIndicators: map['nonFinanctialIndicators'] == null
          ? []
          : (List.from(map['nonFinanctialIndicators']))
              .map((e) => NonFinanctialIndicator.fromMap(e))
              .toList(),
      loan: Loan.fromMap(map['loan']),
      userId: map['userId'],
    );
  }
}
