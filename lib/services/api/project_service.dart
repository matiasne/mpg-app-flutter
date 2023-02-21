import 'dart:convert';
import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/models/weekly_hour.dart';
import 'api.dart';

class ProjectService extends Api {
  ProjectService({required Environments environment})
      : super(environment: environment);


  Future<Project> getProjectById({required int id}) async {
    var url =
        Uri.parse(getEndpoint() + ApiRoutes.project + '/${id.toString()}');

    var response = await client.get(
      url,
      headers: headers,
    );
    return Project.fromMap(json.decode(response.body));
  }

  Future<Project> projectPatchById({
    required int id,
    List<WeeklyHour>? weeklyHours,
    String? creditTerms
  }) async {
    var url =
        Uri.parse(getEndpoint() + ApiRoutes.project + '/${id.toString()}');

    var body = {};

    if (weeklyHours != null) {
      body.addAll({
        'weekHours': weeklyHours.map((e) => e.toMap()).toList(),
      });
    }

    if(creditTerms != null) {
      body.addAll({
        'creditTerms': creditTerms,
      });
    }

    var response = await client.patch(
      url,
      body: json.encode(body),
      headers: headers,
    );
    return Project.fromMap(jsonDecode(response.body));
  }

  Future<List<Project>> getProjectsByCompanyId({required int companyId}) async {
    final queryParams = {
      'companyId': '$companyId',
    };
    var url = Uri.parse(getEndpoint() + ApiRoutes.project)
        .replace(queryParameters: queryParams);

    var response = await client.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body))
        .map((c) => Project.fromMap(c))
        .toList();
  }
}
