import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/models/one_time_effect.dart';
import 'package:mpg_mobile/models/recurring_income.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/account_payables/create_account_payable.dart';

class CashflowAnnualizedService {
  CashFlow? _cashFlow;
  double _total = 0;
  double get total => _total;

  initialize({required CashFlow cashflow}) {
    _cashFlow = cashflow;
    computeTotal();
  }

  computeTotal() {
    _total = 0;
    for (var i = 0; i < _cashFlow!.recurringIncomes.length; i++) {
      RecurringIncome ri = _cashFlow!.recurringIncomes[i];
      double annualizedImpact =
          _computeAnnualizedImpact(amount: ri.amount, freq: ri.freq);
      _total += annualizedImpact;
    }
    for (var i = 0; i < _cashFlow!.oneTimeEffects.length; i++) {
      OneTimeEffect ote = _cashFlow!.oneTimeEffects[i];
      _total += ote.amount;
    }
  }

  List<RecurringIncomeRowData> computeRecurringRowsData() {
    List<RecurringIncomeRowData> rows = [];
    double total = 0;
    double totalPercent = 0;
    for (var i = 0; i < _cashFlow!.recurringIncomes.length; i++) {
      RecurringIncome ri = _cashFlow!.recurringIncomes[i];
      double annualizedImpact =
          _computeAnnualizedImpact(amount: ri.amount, freq: ri.freq);
      total += annualizedImpact;
      totalPercent += _total == 0 ? 0 : ((annualizedImpact / _total) * 100);

      RecurringIncomeRowData rowData = RecurringIncomeRowData(
        description: ri.description,
        freq: ri.freq,
        dueDate: ri.date,
        amount: ri.amount,
        annualizedImpact: annualizedImpact,
        percent: _total == 0 ? 0 : ((annualizedImpact / _total) * 100),
      );
      rows.add(rowData);
    }
    rows.add(RecurringIncomeRowData(
        description: 'Total',
        dueDate: DateTime.now(),
        percent: totalPercent,
        amount: 0,
        freq: '',
        annualizedImpact: total,
        isTotal: true));
    return rows;
  }

  List<OneTimeEffectRowData> computeOneTimeRowsData() {
    List<OneTimeEffectRowData> rows = [];
    double total = 0;
    double totalPercent = 0;
    for (var i = 0; i < _cashFlow!.oneTimeEffects.length; i++) {
      OneTimeEffect ri = _cashFlow!.oneTimeEffects[i];

      total += ri.amount;
      totalPercent += _total == 0 ? 0 : ((ri.amount / _total) * 100);

      OneTimeEffectRowData rowData = OneTimeEffectRowData(
        description: ri.description,
        dueDate: ri.date,
        amount: ri.amount,
        percent: _total == 0 ? 0 : ((ri.amount / _total) * 100),
      );
      rows.add(rowData);
    }
    rows.add(OneTimeEffectRowData(
      description: 'Total',
      dueDate: DateTime.now(),
      amount: total,
      percent: totalPercent,
      isTotal: true,
    ));
    return rows;
  }

  double _computeAnnualizedImpact(
      {required double amount, required String freq}) {
    switch (freq) {
      case FreqSelectOption.monthly:
        return amount * 12;
      case FreqSelectOption.biweekly:
        return amount * 26;
      case FreqSelectOption.weekly:
        return amount * 52;
      default:
        return 0;
    }
  }
}

class RecurringIncomeRowData {
  String description;
  String freq;
  DateTime dueDate;
  double amount;
  double annualizedImpact;
  double percent;
  bool isTotal;

  RecurringIncomeRowData(
      {required this.description,
      required this.freq,
      required this.dueDate,
      required this.amount,
      required this.annualizedImpact,
      required this.percent,
      this.isTotal = false});
}

class OneTimeEffectRowData {
  String description;
  DateTime dueDate;
  double amount;
  double percent;
  bool isTotal;

  OneTimeEffectRowData(
      {required this.description,
      required this.dueDate,
      required this.amount,
      required this.percent,
      this.isTotal = false});
}
