import 'dart:convert';
import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/cost_estimator_form.dart';
import 'package:mpg_mobile/models/customer_info.dart';
import 'package:mpg_mobile/models/project.dart';

import 'api.dart';

class CostEstimatorService extends Api {
  CostEstimatorService({required Environments environment})
      : super(environment: environment);

  Future<void> createCostEstimation(CostEstimatorForm costEstimatorForm) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.costEstimator);
    await client.post(
      url,
      body: json.encode(costEstimatorForm.toMap()),
      headers: headers,
    );
  }

  Future<CustomerInformation> getCustomerInfo() async {
    var url =
        Uri.parse(getEndpoint() + ApiRoutes.costEstimator + ApiRoutes.customer);
    var response = await client.get(
      url,
      headers: headers,
    );
    return CustomerInformation.fromMap(json.decode(response.body));
  }

  Future<Project?> patchByProjectId(
      {required int projectId, required CostEstimatorForm form}) async {
    var url =
        Uri.parse(getEndpoint() + ApiRoutes.costEstimator + '/$projectId');
    var response = await client.patch(
      url,
      body: json.encode(form.toMap()),
      headers: headers,
    );
    return Project.fromMap(json.decode(response.body));
  }

  Uri getDownloadProposalUrl({
    required int projectId,
    required double totalAmount,
  }) {
    final queryParams = {
      'total': '$totalAmount',
    };

    String endpoint = getEndpoint() +
        ApiRoutes.costEstimator +
        '/proposal/${projectId.toString()}/pdf';

    return Uri.parse(endpoint).replace(queryParameters: queryParams);
  }

  Future<void> downloadProposal({
    required int projectId,
    required double totalAmount,
  }) async {
    var url =
        getDownloadProposalUrl(projectId: projectId, totalAmount: totalAmount);
    await client.get(
      url,
      headers: headers,
    );
  }
}
