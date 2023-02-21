import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/company.dart';

class CustomerInformation {
  Company company;
  Client client;

  CustomerInformation({
    required this.company,
    required this.client,
  });

  Map<String, dynamic> toMap() {
    return {
      'company': company.toMap(),
      'client': client.toMap(),
    };
  }

  static CustomerInformation fromMap(Map<String, dynamic> map) {
    return CustomerInformation(
      client: Client.fromMap(map['client']),
      company: Company.fromMap(map['company']),
    );
  }
}