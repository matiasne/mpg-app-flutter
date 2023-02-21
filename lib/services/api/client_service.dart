import 'dart:convert';
import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/models/client.dart';

import 'api.dart';

class ClientService extends Api {
  ClientService({required Environments environment})
      : super(environment: environment);


  Future<Client> createClient({required Client client}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.client);
    var response = await super.client.post(
          url,
          body: json.encode(client.toMap()),
          headers: headers,
        );
    return Client.fromMap(json.decode(response.body));
  }

  Future<void> patch({required Client client}) async {
    var url = Uri.parse(getEndpoint() + ApiRoutes.client + '/${client.id}');
    await super.client.patch(
          url,
          body: json.encode(client.toMap()),
          headers: headers,
        );
  }
}
