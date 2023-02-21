import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';
import 'package:stacked/stacked.dart';

class ScheduleFormViewModel extends BaseViewModel {
  final _proposalSheetFormService = locator<ProposalSheetFormService>();

  DateTime? _beginDate;
  DateTime? _endDate;
  DateTime? get beginDate => _beginDate;
  DateTime? get endDate => _endDate;

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  onModelReady() {
    if (_proposalSheetFormService.startDate != null) {
      setBeginDate(_proposalSheetFormService.startDate);
    }
    if (_proposalSheetFormService.endDate != null) {
      setEndDate(_proposalSheetFormService.endDate);
    }
  }

  setBeginDate(DateTime? date) {
    if (date == null) return;
    startDateController.text = dateFormat.format(date);
    _proposalSheetFormService.setStartDate(date);
    _beginDate = date;
    notifyListeners();
  }

  setEndDate(DateTime? date) {
    if (date == null) return;
    endDateController.text = dateFormat.format(date);
    _proposalSheetFormService.setEndDate(date);
    _endDate = date;
    notifyListeners();
  }
}
