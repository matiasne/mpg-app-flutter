import 'package:mpg_mobile/models/loan.dart';
import 'dart:math' as math;

import 'package:stacked/stacked.dart';

class LoanService with ReactiveServiceMixin {
  Loan? _loan;
  Loan get getLoan => _loan!;
  Frequency _frequency = Frequency.monthly;
  double _interest = 0;
  double _pmt = 0.0;

  final _scheduleEntries = ReactiveValue<List<ScheduleEntry>>([]);
  List<ScheduleEntry> get scheduleEntries => _scheduleEntries.value;

  LoanService() {
    listenToReactiveValues([_scheduleEntries]);
  }

  void setPmt({required double val}) {
    _pmt = val;
    generateScheduleEntries();
  }

  void setFrequency({required Frequency val}) {
    _frequency = val;
    generateScheduleEntries();
  }

  void setInterest(double val) {
    _interest = val;
    generateScheduleEntries();
  }

  initialize({required Loan loan}) {
    _loan = loan;
  }

  double pmt({
    required double rate,
    required int nperiod,
    required double presentValue,
    double futureValue = 0,
    PMTType type = PMTType.beginning,
  }) {
    if (rate == 0) return -(presentValue + futureValue) / nperiod;
    var pvif = math.pow(1 + rate, nperiod);
    double pmt = rate / (pvif - 1) * -(presentValue * pvif + futureValue);
    if (type == PMTType.end) {
      pmt /= (1 + rate);
    }
    return pmt;
  }

  double fv({
    required double rate,
    required int nperiod,
    required double pmt,
    required double presentValue,
  }) {
    num pow = math.pow(1 + rate, nperiod);
    num fv;
    if (rate > 0) {
      fv = (pmt * (1 + rate) * (1 - pow) / rate) - presentValue * pow;
    } else {
      fv = -1 * (presentValue + pmt * nperiod);
    }
    return fv.toDouble();
  }

  List<ScheduleEntry> generateScheduleEntries() {
    if (_loan == null) return [];
    List<DateTime> schedule = _generateSchedule(frequency: _frequency);
    int index = 0;
    List<ScheduleEntry> entries =
        schedule.fold<List<ScheduleEntry>>([], (previousValue, element) {
      // interest, period and pmt are set on the summary.
      int periods = _getPeriods();
      double amountOwing = fv(
          rate: (_interest / 100) / periods,
          nperiod: index,
          pmt: _pmt,
          presentValue: -_loan!.loanAmount);

      ScheduleEntry entry = ScheduleEntry(
        date: element,
        pmtNumber: index,
        amountOwing: amountOwing,
      );
      index++;
      return [...previousValue, entry];
    });

    _scheduleEntries.value = entries;
    return entries;
  }

  int _getPeriods() {
    switch (_frequency) {
      case (Frequency.monthly):
        return 12;
      case (Frequency.weekly):
        return 52;
      case (Frequency.biWeekly):
        return 26;
    }
    return 1;
  }

  List<DateTime> _generateSchedule({required Frequency frequency}) {
    if (_loan == null) return [];
    DateTime startDate = _loan!.startDate;
    DateTime endDate = DateTime(
      startDate.year + _loan!.numberOfYears,
      startDate.month,
      startDate.day,
    );

    switch (frequency) {
      case (Frequency.monthly):
        return _generateMonthlyDates(
          startDate: startDate,
          endDate: endDate,
        );
      case (Frequency.weekly):
        return _generateWeeklyDates(
          startDate: startDate,
          endDate: endDate,
        );
      case (Frequency.biWeekly):
        return _generateWeeklyDates(
          startDate: startDate,
          endDate: endDate,
          isBiWeekly: true,
        );
    }
    return _generateMonthlyDates(
      startDate: startDate,
      endDate: endDate,
    );
  }

  List<DateTime> _generateMonthlyDates({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final daysToGenerate = endDate.difference(startDate).inDays;
    return List.generate(
      daysToGenerate,
      (i) => DateTime(
        startDate.year,
        startDate.month,
        startDate.day + (i),
      ),
    ).where((d) => d.day == 1).toList();
  }

  List<DateTime> _generateWeeklyDates({
    required DateTime startDate,
    required DateTime endDate,
    bool isBiWeekly = false,
  }) {
    final daysToGenerate = endDate.difference(startDate).inDays;
    List<DateTime> schedule = List.generate(
      daysToGenerate,
      (i) => DateTime(
        startDate.year,
        startDate.month,
        startDate.day + (i),
      ),
    ).where((d) => d.weekday == DateTime.sunday).toList();
    if (isBiWeekly) {
      return schedule.where((s) => ((schedule.indexOf(s) % 2) == 0)).toList();
    }
    return schedule;
  }

  dispose() {
    _loan = null;
  }
}

class ScheduleEntry {
  int pmtNumber;
  DateTime date;
  double amountOwing;
  ScheduleEntry({
    required this.pmtNumber,
    required this.date,
    required this.amountOwing,
  });
}

enum PMTType { end, beginning }
enum Frequency { monthly, weekly, biWeekly }
