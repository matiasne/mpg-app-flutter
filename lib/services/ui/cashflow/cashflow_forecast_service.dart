import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/ui/views/cashflow/create/debt_services/create_debt_service_view.dart';

class CashflowForecastService {
  CashFlow? _cashFlow;

  // cashflow
  List<double> _businessCheckingAccount = [];
  List<double> _totalCashAvailable = [];
  List<double> _totalExpenses = [];
  List<double> _emergencyCashBalance = [];

  Map<int, String> tableNames = {
    TableType.cashflow: 'Casflow',
    TableType.ap: 'Payables',
    TableType.ar: 'Receivables',
    TableType.changeImpact: 'Change Impact',
    TableType.clientRev: 'Clients Revenue',
    TableType.debt: 'Debt Services',
    TableType.businessExpenses: 'Business Expenses',
  };

  initialize({required CashFlow cashflow}) {
    _cashFlow = cashflow;
  }

  DateTime? get startDate => _cashFlow?.startDate;

  bool _isPayday({
    required int number,
    required String freq,
    required DateTime date,
    required DateTime previousDate,
  }) {
    DateTime startDate = _cashFlow!.startDate;
    int differenceInDays = startDate.difference(date).inDays;
    if (freq == FreqSelectOption.weekly) {
      return true;
    }

    if (freq == FreqSelectOption.biweekly) {
      return differenceInDays % 2 == 0;
    }

    if (freq == FreqSelectOption.monthly) {
      int previousNumber = previousDate.day;
      int currentNumber = date.day;
      if (currentNumber > previousNumber) {
        return number > previousNumber && number <= currentNumber;
      } else {
        return number > previousNumber || number <= currentNumber;
      }
    }

    return false;
  }

  List<_RowData> getDataByType({required int type}) {
    switch (type) {
      case TableType.ar:
        {
          return _cashFlow!.accountReceivables
              .map((e) => _RowData(
                    description: e.description,
                    amount: e.amount,
                    date: e.date,
                  ))
              .toList();
        }
      case TableType.ap:
        {
          return _cashFlow!.accountPayables
              .map((e) => _RowData(
                    description: e.description,
                    amount: e.amount,
                    date: e.date,
                  ))
              .toList();
        }
      case TableType.changeImpact:
        {
          return _cashFlow!.oneTimeEffects
              .map((e) => _RowData(
                    description: e.description,
                    amount: e.amount,
                    date: e.date,
                  ))
              .toList();
        }
      case TableType.clientRev:
        {
          return _cashFlow!.recurringIncomes
              .map((e) => _RowData(
                    description: e.description,
                    amount: e.amount,
                    date: e.date,
                    freq: e.freq,
                    periodNumber: e.periodNumber,
                  ))
              .toList();
        }
      case TableType.debt:
        {
          return _cashFlow!.debtServices
              .map((e) => _RowData(
                    description: e.description,
                    amount: e.amount,
                    date: e.date,
                    freq: e.freq,
                    periodNumber: e.periodNumber,
                  ))
              .toList();
        }
      case TableType.businessExpenses:
        {
          return _cashFlow!.businessExpenses
              .map((e) => _RowData(
                    description: e.description,
                    amount: e.amount,
                    date: e.date,
                    freq: e.freq,
                    periodNumber: e.periodNumber,
                  ))
              .toList();
        }
    }
    return [];
  }

  List<ForecastRowContent> getRowData({
    required int weeksToProject,
    required int type,
    RowRequest request = RowRequest.all,
  }) {
    if (type == TableType.cashflow) {
      return generateForCashflow(weeksToProject: weeksToProject);
    }
    List<int> tablesWithFreq = [TableType.clientRev, TableType.debt];
    bool withFreq = tablesWithFreq.contains(type);
    List<ForecastRowContent> rowsContent = [];
    double totalAmount = 0;
    List<double> totalWeekValues = List.generate(weeksToProject, (index) => 0);
    List<_RowData> data = getDataByType(type: type);

    for (var rowData in data) {
      String description = rowData.description;
      double amount = rowData.amount;
      int? periodNumber = withFreq ? rowData.periodNumber : null;
      DateTime paydate = rowData.date;
      String? freq = withFreq ? rowData.freq : null;
      DateTime date = _cashFlow!.startDate;
      List<double?> weeklyValues = [];

      for (var i = 0; i < (weeksToProject); i++) {
        DateTime previousDate = date;
        date = date.add(const Duration(days: 7));

        // calculate paydate depending of the table type
        bool isPayday = withFreq
            ? _isPayday(
                number: periodNumber!,
                freq: freq!,
                date: date,
                previousDate: previousDate)
            : (paydate.isAfter(previousDate) && paydate.isBefore(date)) ||
                paydate.isAtSameMomentAs(date);

        weeklyValues.add(isPayday ? rowData.amount : null);
        double finalValue = isPayday ? rowData.amount : 0;
        if ((type == TableType.clientRev ||
                type == TableType.ar ||
                type == TableType.changeImpact) &&
            i < _totalCashAvailable.length) {
          _totalCashAvailable[i] += finalValue;
        }
        if ((type == TableType.businessExpenses ||
                type == TableType.debt ||
                type == TableType.ap) &&
            i < _totalCashAvailable.length) {
          _totalExpenses[i] += finalValue;
        }
        totalWeekValues[i] += finalValue;
      }

      // adds new body row
      if (request != RowRequest.totals) {
        rowsContent.add(ForecastRowContent(
            description: description,
            freq: freq,
            due: amount,
            periodNumber: periodNumber,
            payDate: paydate,
            weeklyValues: weeklyValues));
      }
      totalAmount += rowData.amount;
    }

    // totals section
    if (request != RowRequest.body) {
      rowsContent.add(ForecastRowContent(
          description: 'Total Weekly ${tableNames[type]}',
          freq: withFreq ? '' : null,
          due: withFreq || request == RowRequest.totals ? null : totalAmount,
          payDate: null,
          weeklyValues: totalWeekValues));
    }

    return rowsContent;
  }

  List<double> computeBusinessPayrollAccount({required int weeksToProject}) {
    List<double> totalWeekValues = List.generate(weeksToProject, (index) => 0);
    totalWeekValues[0] = _cashFlow!.payrollAccount;
    _totalCashAvailable[0] += _cashFlow!.payrollAccount;
    return totalWeekValues;
  }

  List<double> computeBusinessSavingsAccount({required int weeksToProject}) {
    List<double> totalWeekValues = List.generate(weeksToProject, (index) => 0);
    totalWeekValues[0] = _cashFlow!.savingsAccount;
    _totalCashAvailable[0] += _cashFlow!.savingsAccount;
    return totalWeekValues;
  }

  List<double> computeBusinessCheckingAccount() {
    List<double> totalWeekValues =
        List.generate(_businessCheckingAccount.length, (index) => 0);
    totalWeekValues[0] += _cashFlow!.checkingAccount;
    _totalCashAvailable[0] += _cashFlow!.checkingAccount;
    for (var i = 1; i < totalWeekValues.length; i++) {
      totalWeekValues[i] = _totalCashAvailable[i - 1] - _totalExpenses[i - 1];
      _totalCashAvailable[i] += totalWeekValues[i];
    }
    return totalWeekValues;
  }

  List<double> computeProjectedEndingCash() {
    List<double> totalWeekValues =
        List.generate(_totalCashAvailable.length, (index) => 0);
    for (var i = 0; i < _totalCashAvailable.length; i++) {
      totalWeekValues[i] = _totalCashAvailable[i] - _totalExpenses[i];
      _emergencyCashBalance[i] += totalWeekValues[i];
    }
    return totalWeekValues;
  }

  List<double> computeBorrowingSavingsRow() {
    return List.generate(_businessCheckingAccount.length, (index) {
      _emergencyCashBalance[index] += _cashFlow!.borrowingSavings;
      return _cashFlow!.borrowingSavings;
    });
  }

  List<double> computeLOCsRow() {
    return List.generate(
        _businessCheckingAccount.length, (index) => _cashFlow!.totalLocs);
  }

  List<double> computeOutstandingDrawsRow() {
    return List.generate(_businessCheckingAccount.length,
        (index) => _cashFlow!.outstandingDraws);
  }

  List<double> computeLOCsBalanceRow() {
    return List.generate(_businessCheckingAccount.length, (index) {
      _emergencyCashBalance[index] += _cashFlow!.locsBalance;
      return _cashFlow!.locsBalance;
    });
  }

  List<double> computeOtherSavingsRow() {
    return List.generate(_businessCheckingAccount.length, (index) {
      _emergencyCashBalance[index] += _cashFlow!.otherSavings;
      return _cashFlow!.otherSavings;
    });
  }

  List<ForecastRowContent> generateForCashflow({required int weeksToProject}) {
    List<ForecastRowContent> rowsContent = [];
    List<double?> emptyWeekValues =
        List.generate(weeksToProject, (index) => null);
    List<double> initialWeekValues =
        List.generate(weeksToProject, (index) => 0);

    _businessCheckingAccount = [...initialWeekValues];
    _totalCashAvailable = [...initialWeekValues];
    _totalExpenses = [...initialWeekValues];
    _emergencyCashBalance = [...initialWeekValues];

    // recurring income title
    rowsContent.add(ForecastRowContent(
        description: 'Revenue / Inflows',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: emptyWeekValues));

    // Business Payroll account title
    rowsContent.add(ForecastRowContent(
        description: 'Payroll account',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues:
            computeBusinessPayrollAccount(weeksToProject: weeksToProject)));

    // Business Savings account title
    rowsContent.add(ForecastRowContent(
        description: 'Savings account',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues:
            computeBusinessSavingsAccount(weeksToProject: weeksToProject)));

    // Recurring income section
    rowsContent.addAll(getRowData(
        weeksToProject: weeksToProject,
        type: TableType.clientRev,
        request: RowRequest.body));

    // Separator title
    rowsContent.add(ForecastRowContent(
        description: '',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: emptyWeekValues));

    // A-R Totals section
    rowsContent.addAll(getRowData(
        weeksToProject: weeksToProject,
        type: TableType.ar,
        request: RowRequest.totals));

    // Change impact Totals section
    rowsContent.addAll(getRowData(
        weeksToProject: weeksToProject,
        type: TableType.changeImpact,
        request: RowRequest.totals));

    // Totals title
    rowsContent.add(ForecastRowContent(
        description: 'Total Cash Available',
        freq: null,
        due: null,
        payDate: null,
        // todo: sum business revenue + ar + one time effects
        weeklyValues: _totalCashAvailable));

    // Separator title
    rowsContent.add(ForecastRowContent(
        description: '',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: emptyWeekValues));

    // Business expenses Totals section
    rowsContent.addAll(getRowData(
        weeksToProject: weeksToProject,
        type: TableType.businessExpenses,
        request: RowRequest.totals));

    // Debt Totals section
    rowsContent.addAll(getRowData(
        weeksToProject: weeksToProject,
        type: TableType.debt,
        request: RowRequest.totals));

    // A-P Totals section
    rowsContent.addAll(getRowData(
        weeksToProject: weeksToProject,
        type: TableType.ap,
        request: RowRequest.totals));

    // Totals title
    rowsContent.add(ForecastRowContent(
        description: 'Total expenses',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: _totalExpenses));

    // Business Checking account
    rowsContent.insert(
        1,
        ForecastRowContent(
            description: 'Business Checking account',
            freq: null,
            due: null,
            payDate: null,
            weeklyValues: computeBusinessCheckingAccount()));

    // Separator title
    rowsContent.add(ForecastRowContent(
        description: '',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: emptyWeekValues));

    rowsContent.add(ForecastRowContent(
        description: 'Projected ending cash',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: computeProjectedEndingCash()));

    rowsContent.add(ForecastRowContent(
        description: 'Projected Savings',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: computeBorrowingSavingsRow()));

    rowsContent.add(ForecastRowContent(
        description: 'Projected LOCs',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: computeLOCsRow()));

    rowsContent.add(ForecastRowContent(
        description: 'Projected Outstanding Draws',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: computeOutstandingDrawsRow()));

    rowsContent.add(ForecastRowContent(
        description: 'Projected LOCs Balance',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: computeLOCsBalanceRow()));

    rowsContent.add(ForecastRowContent(
        description: 'Projected Other Savings',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: computeOtherSavingsRow()));

    rowsContent.add(ForecastRowContent(
        description: 'Emergency Cash balance',
        freq: null,
        due: null,
        payDate: null,
        weeklyValues: _emergencyCashBalance));

    return rowsContent;
  }
}

enum RowRequest { all, body, totals }

class ForecastRowContent {
  String description;
  String? freq;
  double? due;
  DateTime? payDate;
  List<double?> weeklyValues;
  int? periodNumber;

  ForecastRowContent({
    required this.description,
    this.freq,
    required this.due,
    required this.payDate,
    required this.weeklyValues,
    this.periodNumber,
  });
}

class _RowData {
  String description;
  int? periodNumber;
  String? freq;
  double amount;
  DateTime date;

  _RowData({
    required this.description,
    this.freq,
    this.periodNumber,
    required this.amount,
    required this.date,
  });
}

class TableType {
  static const int cashflow = 1;
  static const int ar = 2;
  static const int ap = 3;
  static const int changeImpact = 4;
  static const int debt = 5;
  static const int clientRev = 6;
  static const int businessExpenses = 7;
}
