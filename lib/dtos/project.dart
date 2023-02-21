import 'package:mpg_mobile/models/labor_cost.dart';
import 'package:mpg_mobile/models/material_cost.dart';
import 'package:mpg_mobile/models/scope.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'package:mpg_mobile/models/key_assumption.dart';
import 'package:mpg_mobile/models/objective.dart';

class ProjectInfoDTO {
  String name;
  String number;
  String jobDescription;
  String jobLocation;

  ProjectInfoDTO(
      {required this.name,
      required this.number,
      required this.jobDescription,
      required this.jobLocation});
}

class ProjectCostsDTO {
  double taxRatio;
  double fringeRate;
  double contingencyRate;
  double salesComission;
  double desiredProfit;
  double squareFeet;
  List<MaterialCost> materialCosts;
  List<LaborCost> laborCosts;

  ProjectCostsDTO(
      {required this.taxRatio,
      required this.fringeRate,
      required this.contingencyRate,
      required this.salesComission,
      required this.desiredProfit,
      required this.squareFeet,
      required this.materialCosts,
      required this.laborCosts});
}

class ProjectProposalInfoDTO {
  List<Objective> objectives;
  List<Scope> scopes;
  List<KeyAssumption> keyAssumptions;
  DateTime? startDate;
  DateTime? endDate;
  List<WeeklyHour> weekHours;

  ProjectProposalInfoDTO({
    required this.objectives,
    required this.scopes,
    required this.keyAssumptions,
    required this.startDate,
    required this.endDate,
    required this.weekHours,
  });
}
