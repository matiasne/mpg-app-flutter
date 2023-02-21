import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/services/ui/business_valuation/loan.service.dart';
import 'package:stacked/stacked.dart';

class LoanSummaryViewModel extends BaseViewModel {
  final _loanService = locator<LoanService>();

  String _frequency = 'Monthly';
  String get frequency => _frequency;

  List<String> frequencies = [
    Frequencies.monthly,
    Frequencies.weekly,
    Frequencies.biweekly
  ];
  Map<String, int> frecuencyValues = {
    Frequencies.monthly: 12,
    Frequencies.weekly: 52,
    Frequencies.biweekly: 26,
  };

  Loan get loan => _loanService.getLoan;

  double _monthlyPayment = 0.0;
  double get monthlyPayment => _monthlyPayment;
  double get annualPayment =>
      _monthlyPayment * (frecuencyValues[_frequency] ?? 1);

  double _interest = 0.0;

  onFrequencyChanged(String? val) {
    if (val == null) return;
    _frequency = val;

    Frequency type = getTypeByFrequency(val);
    _loanService.setFrequency(val: type);
    computeMonthlyPayment();
  }

  Frequency getTypeByFrequency(String frecuency) {
    if (_frequency == Frequencies.monthly) return Frequency.monthly;
    if (_frequency == Frequencies.weekly) return Frequency.weekly;
    if (_frequency == Frequencies.biweekly) return Frequency.biWeekly;
    return Frequency.monthly;
  }

  onInterestChanged(String? val) {
    if (val == null) return;
    _interest = double.tryParse(val) ?? 0.0;
    _loanService.setInterest(_interest);
    computeMonthlyPayment();
  }

  computeMonthlyPayment() {
    int frecuency = frecuencyValues[_frequency] ?? 1;
    _monthlyPayment = _loanService.pmt(
        rate: (_interest / 100) / frecuency,
        nperiod: loan.numberOfYears * frecuency,
        presentValue: -loan.loanAmount);
    
    _loanService.setPmt(val: _monthlyPayment);
    notifyListeners();
  }
}

class Frequencies {
  static String monthly = 'Monthly';
  static String weekly = 'Weekly';
  static String biweekly = 'Bi-Weekly';
}
