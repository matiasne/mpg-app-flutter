import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/company.dart';
import 'package:mpg_mobile/models/project.dart';

class ProjectInfo {
  Project project;
  Client client;
  Company company;

  ProjectInfo(
      {required this.project, required this.client, required this.company});

  Map<String, dynamic> toMap() {
    return {
      'project': project,
      'client': client,
      'company': company,
    };
  }

  static ProjectInfo fromMap(Map<String, dynamic> map) {
    return ProjectInfo(
      project: map['project'],
      client: map['client'],
      company: map['company'],
    );
  }

  @override
  String toString() {
    return 'project: ${project.toString()}, client: ${client.toString()}, company: ${company.toString()}';
  }
}
