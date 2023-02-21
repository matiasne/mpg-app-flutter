import 'dart:convert';
import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/client.dart';

import 'api.dart';

class CompanyService extends Api {
  CompanyService({required Environments environment})
      : super(environment: environment);


  Future<List<Client>> getClientsForCompany({required int companyId}) async {
    var url =
        Uri.parse(getEndpoint() + ApiRoutes.company + '/clients/$companyId');
    var response = await client.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body))
        .map((c) => Client.fromMap(c))
        .toList();
  }
}
