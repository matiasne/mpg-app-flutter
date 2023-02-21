import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/models/key_assumption.dart';
import 'package:mpg_mobile/models/objective.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/models/scope.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'package:stacked/stacked.dart';

class ListType {
  static const objective = 'objective';
  static const scope = 'scope';
  static const keyAssumption = 'keyAssumption';
}

class ProposalSheetFormService with ReactiveServiceMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<Objective> objectives = [];
  List<Scope> scopes = [];
  List<KeyAssumption> keyAssumptions = [];
  final ReactiveValue<DateTime?> _startDate = ReactiveValue<DateTime?>(null);
  final ReactiveValue<DateTime?> _endDate = ReactiveValue<DateTime?>(null);
  List<WeeklyHour> weekHours = [];

  DateTime? get startDate => _startDate.value;
  DateTime? get endDate => _endDate.value;

  bool _isEdit = false;
  bool get isEdit => _isEdit;

  TextEditingController projectNameController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();
  TextEditingController jobLocationController = TextEditingController();
  TextEditingController projectNumberController = TextEditingController();

  ProposalSheetFormService() {
    listenToReactiveValues([_startDate, _endDate]);
  }

  loadForEdit({required Project project}) {
    _isEdit = true;
    objectives = project.objectives;
    scopes = project.scopes;
    keyAssumptions = project.keyAssumptions;
    setStartDate(project.startDate);
    setEndDate(project.endDate);
    projectNameController = TextEditingController(text: project.name);
    jobDescriptionController =
        TextEditingController(text: project.jobDescription);
    jobLocationController = TextEditingController(text: project.jobLocation);
    projectNumberController = TextEditingController(text: project.number);
    weekHours = project.weekHours;
  }

  setStartDate(DateTime? date) {
    _startDate.value = date;
  }

  setEndDate(DateTime? date) {
    _endDate.value = date;
  }

  addListItem(String description, String type) {
    switch (type) {
      case ListType.objective:
        {
          objectives.add(Objective(description: description));
          break;
        }
      case ListType.scope:
        {
          scopes.add(Scope(description: description));
          break;
        }
      case ListType.keyAssumption:
        {
          keyAssumptions.add(KeyAssumption(description: description));
          break;
        }
      default:
        break;
    }
  }

  removeListItem(int index, String type) {
    switch (type) {
      case ListType.objective:
        {
          objectives.removeAt(index);
          break;
        }
      case ListType.scope:
        {
          scopes.removeAt(index);
          break;
        }
      case ListType.keyAssumption:
        {
          keyAssumptions.removeAt(index);
          break;
        }
      default:
        break;
    }
  }

  dispose() {
    objectives = [];
    scopes = [];
    keyAssumptions = [];
    _startDate.value = null;
    _endDate.value = null;
    weekHours = [];
    projectNameController = TextEditingController();
    jobDescriptionController = TextEditingController();
    jobLocationController = TextEditingController();
    projectNumberController = TextEditingController();
  }
}
