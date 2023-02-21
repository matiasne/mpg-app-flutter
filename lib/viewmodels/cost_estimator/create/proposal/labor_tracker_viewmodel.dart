import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';
import 'package:stacked/stacked.dart';

class LaborTrackerViewModel extends ReactiveViewModel {
  final _proposalSheetService = locator<ProposalSheetFormService>();

  List<WeeklyHour> _weekHours = [];
  List<WeeklyHour> get weekHours => _weekHours;

  double _totalHours = 0.0;
  double get totalHours => _totalHours;

  DateTime? _lastStartDate;
  DateTime? _lastEndDate;
  DateTime? get startDate => _proposalSheetService.startDate;
  DateTime? get endDate => _proposalSheetService.endDate;

  onModelReady() {
    if (_proposalSheetService.isEdit) {
      _lastStartDate = _proposalSheetService.startDate;
      _lastEndDate = _proposalSheetService.endDate;
      _weekHours = _proposalSheetService.weekHours;
      updateTotal();
    }
  }

  onChangeWeeklyHour(int index, String val) {
    double hours = 0;
    if (val != '') hours = double.parse(val);
    _proposalSheetService.weekHours
        .firstWhere((e) => e.day == _proposalSheetService.weekHours[index].day)
        .hours = hours;
    updateTotal();
  }

  updateTotal() {
    double total = _proposalSheetService.weekHours
        .fold<double>(0.0, (double value, element) => value += element.hours);
    _totalHours = total;
    notifyListeners();
  }

  void generateSundayEntries(DateTime? _startDate, DateTime? _endDate) {
    if (_startDate == null || _endDate == null) return;
    if (!_shouldCreateEntries(_startDate, _endDate)) return;

    _lastStartDate = _startDate;
    _lastEndDate = _endDate;

    final daysToGenerate = _endDate.difference(_startDate).inDays;
    List<WeeklyHour> sundays = List.generate(
      daysToGenerate,
      (i) => WeeklyHour(
        day: DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day + (i),
        ),
      ),
    ).where((e) => e.day.weekday == DateTime.sunday).toList();
    _proposalSheetService.weekHours = sundays;
    _weekHours = sundays;
  }

  _shouldCreateEntries(DateTime _startDate, DateTime _endDate) {
    bool shouldCreate = _startDate.isBefore(_endDate) &&
        (_startDate != _lastStartDate || _endDate != _lastEndDate);
    return shouldCreate;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_proposalSheetService];
}
