import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/company.dart';
import 'package:mpg_mobile/models/project.dart';

class CostEstimatorForm {
  Project project;
  Company company;
  Client client;

  CostEstimatorForm({
    required this.project,
    required this.company,
    required this.client,
  });

  Map<String, dynamic> toMap() {
    return {
      'project': project.toMap(),
      'company': company.toMap(),
      'client': client.toMap(),
    };
  }
}
