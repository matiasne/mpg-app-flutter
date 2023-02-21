import 'dart:convert';
import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/business_valuation.dart';

import 'api.dart';

class BusinessValuationApiService extends Api {
  BusinessValuationApiService({required Environments environment})
      : super(environment: environment);

  Future<BusinessValuation> create({required BusinessValuation bv}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.businessValuation);
    var response = await super.client.post(
          url,
          body: json.encode(bv.toMap()),
          headers: headers,
        );
    return BusinessValuation.fromMap(json.decode(response.body));
  }

  Future<BusinessValuation?> getById({required int id}) async {
    final queryParams = {
      'id': '$id',
    };
    var url = Uri.parse(getEndpoint() + ApiRoutes.businessValuation)
        .replace(queryParameters: queryParams);

    var response = await client.get(
      url,
      headers: headers,
    );
    return BusinessValuation.fromMap(json.decode(response.body));
  }

  Future<List<BusinessValuation>> getAllByUserId({required int userId}) async {
    final queryParams = {
      'userId': '$userId',
    };
    var url = Uri.parse(getEndpoint() + ApiRoutes.businessValuation + '/user')
        .replace(queryParameters: queryParams);

    var response = await client.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body))
        .map((c) => BusinessValuation.fromMap(c))
        .toList();
  }
}
