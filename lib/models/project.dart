import 'package:mpg_mobile/models/labor_cost.dart';
import 'package:mpg_mobile/models/material_cost.dart';
import 'package:mpg_mobile/models/scope.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'package:mpg_mobile/models/key_assumption.dart';
import 'package:mpg_mobile/models/objective.dart';

import 'client.dart';

class Project {
  int? id;
  String name;
  String number;
  String jobDescription;
  String jobLocation;
  DateTime startDate;
  DateTime endDate;
  double taxRatio;
  double fringeRate;
  double contingencyRate;
  double salesComission;
  double desiredProfit;
  double squareFeet;
  List<MaterialCost> materialCosts;
  List<LaborCost> laborCosts;
  List<WeeklyHour> weekHours;
  List<KeyAssumption> keyAssumptions;
  List<Objective> objectives;
  List<Scope> scopes;
  Client? client;
  String? creditTerms;

  Project({
    this.id,
    required this.name,
    required this.number,
    required this.jobDescription,
    required this.jobLocation,
    required this.startDate,
    required this.endDate,
    required this.taxRatio,
    required this.fringeRate,
    required this.contingencyRate,
    required this.salesComission,
    required this.desiredProfit,
    required this.squareFeet,
    required this.materialCosts,
    required this.laborCosts,
    required this.weekHours,
    required this.keyAssumptions,
    required this.objectives,
    required this.scopes,
    this.client,
    this.creditTerms,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'jobDescription': jobDescription,
      'jobLocation': jobLocation,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'taxRatio': taxRatio,
      'fringeRate': fringeRate,
      'contingencyRate': contingencyRate,
      'salesComission': salesComission,
      'desiredProfit': desiredProfit,
      'squareFeet': squareFeet,
      'materialCosts': materialCosts.map((e) => e.toMap()).toList(),
      'laborCosts': laborCosts.map((e) => e.toMap()).toList(),
      'weekHours': weekHours.map((e) => e.toMap()).toList(),
      'keyAssumptions': keyAssumptions.map((e) => e.toMap()).toList(),
      'objectives': objectives.map((e) => e.toMap()).toList(),
      'scopes': scopes.map((e) => e.toMap()).toList(),
      'creditTerms': creditTerms,
    };
  }

  static Project fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      number: map['number'],
      jobDescription: map['jobDescription'],
      jobLocation: map['jobLocation'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      taxRatio: map['taxRatio'].toDouble(),
      fringeRate: map['fringeRate'].toDouble(),
      contingencyRate: map['contingencyRate'].toDouble(),
      salesComission: map['salesComission'].toDouble(),
      desiredProfit: map['desiredProfit'].toDouble(),
      squareFeet: map['squareFeet'].toDouble(),
      creditTerms: map['creditTerms'],
      materialCosts: map['materialCosts'] == null
          ? []
          : (List.from(map['materialCosts']))
              .map((e) => MaterialCost.fromMap(e))
              .toList(),
      laborCosts: map['laborCosts'] == null
          ? []
          : (List.from(map['laborCosts']))
              .map((e) => LaborCost.fromMap(e))
              .toList(),
      weekHours: map['weekHours'] == null
          ? []
          : (List.from(map['weekHours']))
              .map((e) => WeeklyHour.fromMap(e))
              .toList(),
      keyAssumptions: map['keyAssumptions'] == null
          ? []
          : (List.from(map['keyAssumptions']))
              .map((e) => KeyAssumption.fromMap(e))
              .toList(),
      objectives: map['objectives'] == null
          ? []
          : (List.from(map['objectives']))
              .map((e) => Objective.fromMap(e))
              .toList(),
      scopes: map['scopes'] == null
          ? []
          : (List.from(map['scopes'])).map((e) => Scope.fromMap(e)).toList(),
      client: map['client'] == null ? null : Client.fromMap(map['client']),
    );
  }
}
