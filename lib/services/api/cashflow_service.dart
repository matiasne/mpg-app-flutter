import 'dart:convert';

import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/models/http_error.dart';

import 'api.dart';

class CashflowApiService extends Api {
  CashflowApiService({required Environments environment})
      : super(environment: environment);

  Future<void> create({required CashFlow cashflow}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.cashflow);
    var response = await super.client.post(
          url,
          body: json.encode(cashflow.toMap()),
          headers: headers,
        );
    bool hasErrors = response.statusCode >= 400;
    if (hasErrors) throw HttpError.fromMap(jsonDecode(response.body));
  }

  Future<CashFlow?> getById({required int id}) async {
    final queryParams = {
      'id': '$id',
    };
    var url = Uri.parse(getEndpoint() + ApiRoutes.cashflow)
        .replace(queryParameters: queryParams);

    var response = await client.get(
      url,
      headers: headers,
    );
    return CashFlow.fromMap(json.decode(response.body));
  }

  Future<List<CashFlow>> getAllByUserId({required int userId}) async {
    final queryParams = {
      'userId': '$userId',
    };
    var url = Uri.parse(getEndpoint() + ApiRoutes.cashflow + '/user')
        .replace(queryParameters: queryParams);
    var response = await client.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(json.decode(response.body))
        .map((c) => CashFlow.fromMap(c))
        .toList();
  }
}
