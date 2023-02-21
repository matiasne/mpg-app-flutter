import 'package:mpg_mobile/models/account_payable.dart';
import 'package:mpg_mobile/models/account_receivable.dart';
import 'package:mpg_mobile/models/business_expense.dart';
import 'package:mpg_mobile/models/debt_service.dart';
import 'package:mpg_mobile/models/one_time_effect.dart';
import 'package:mpg_mobile/models/recurring_income.dart';

class CashFlow {
  int? id;
  int? userId;
  String name;
  double checkingAccount;
  double payrollAccount;
  double savingsAccount;
  DateTime startDate;
  List<RecurringIncome> recurringIncomes;
  List<AccountReceivable> accountReceivables;
  List<BusinessExpense> businessExpenses;
  List<OneTimeEffect> oneTimeEffects;
  List<DebtService> debtServices;
  List<AccountPayable> accountPayables;
  double borrowingSavings;
  double totalLocs;
  double outstandingDraws;
  double locsBalance;
  double otherSavings;

  CashFlow({
    this.id,
    required this.name,
    this.userId,
    required this.checkingAccount,
    required this.payrollAccount,
    required this.savingsAccount,
    required this.startDate,
    required this.recurringIncomes,
    required this.accountReceivables,
    required this.businessExpenses,
    required this.oneTimeEffects,
    required this.debtServices,
    required this.accountPayables,
    required this.borrowingSavings,
    required this.totalLocs,
    required this.outstandingDraws,
    required this.locsBalance,
    required this.otherSavings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'checkingAccount': checkingAccount,
      'payrollAccount': payrollAccount,
      'savingsAccount': savingsAccount,
      'startDate': startDate.toIso8601String(),
      'recurringIncomes': recurringIncomes.map((e) => e.toMap()).toList(),
      'accountReceivables': accountReceivables.map((e) => e.toMap()).toList(),
      'businessExpenses': businessExpenses.map((e) => e.toMap()).toList(),
      'oneTimeEffects': oneTimeEffects.map((e) => e.toMap()).toList(),
      'debtServices': debtServices.map((e) => e.toMap()).toList(),
      'accountPayables': accountPayables.map((e) => e.toMap()).toList(),
      'borrowingSavings': borrowingSavings,
      'totalLocs': totalLocs,
      'outstandingDraws': outstandingDraws,
      'locsBalance': locsBalance,
      'otherSavings': otherSavings,
    };
  }

  static CashFlow fromMap(Map<String, dynamic> map) {
    return CashFlow(
      id: map['id'],
      name: map['name'],
      userId: map['userId'],
      checkingAccount: map['checkingAccount']?.toDouble(),
      payrollAccount: map['payrollAccount']?.toDouble(),
      savingsAccount: map['savingsAccount']?.toDouble(),
      startDate: DateTime.parse(map['startDate']),
      recurringIncomes: map['recurringIncomes'] == null
          ? []
          : (map['recurringIncomes'] as List)
              .map((e) => RecurringIncome.fromMap(e))
              .toList(),
      accountReceivables: map['accountReceivables'] == null
          ? []
          : (map['accountReceivables'] as List)
              .map((e) => AccountReceivable.fromMap(e))
              .toList(),
      businessExpenses: map['businessExpenses'] == null
          ? []
          : (map['businessExpenses'] as List)
              .map((e) => BusinessExpense.fromMap(e))
              .toList(),
      oneTimeEffects: map['oneTimeEffects'] == null
          ? []
          : (map['oneTimeEffects'] as List)
              .map((e) => OneTimeEffect.fromMap(e))
              .toList(),
      debtServices: map['debtServices'] == null
          ? []
          : (map['debtServices'] as List)
              .map((e) => DebtService.fromMap(e))
              .toList(),
      accountPayables: map['accountPayables'] == null
          ? []
          : (map['accountPayables'] as List)
              .map((e) => AccountPayable.fromMap(e))
              .toList(),
      borrowingSavings: map['borrowingSavings']?.toDouble(),
      totalLocs: map['totalLocs']?.toDouble(),
      outstandingDraws: map['outstandingDraws']?.toDouble(),
      locsBalance: map['locsBalance']?.toDouble(),
      otherSavings: map['otherSavings']?.toDouble(),
    );
  }
}
