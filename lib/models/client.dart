import 'company.dart';

class Client {
  int? id;
  String name;
  String contactName;
  String address;
  String cityState;
  String zipCode;
  String phoneNumber;
  String email;
  double? annualSalesRevenue;
  double? annualCostOfGoodsSold;
  double? annualFixedExpenses;
  double? overheadRatio;
  Company? company;

  Client({
    this.id,
    required this.name,
    required this.contactName,
    required this.address,
    required this.cityState,
    required this.zipCode,
    required this.phoneNumber,
    required this.email,
    this.annualSalesRevenue,
    this.annualCostOfGoodsSold,
    this.annualFixedExpenses,
    this.overheadRatio,
    this.company,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactName': contactName,
      'address': address,
      'cityState': cityState,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'email': email,
      'annualSalesRevenue': annualSalesRevenue,
      'annualCostOfGoodsSold': annualCostOfGoodsSold,
      'annualFixedExpenses': annualFixedExpenses,
      'overheadRatio': overheadRatio,
      'company': company?.toMap()
    };
  }

  static Client fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      contactName: map['contactName'],
      address: map['address'],
      cityState: map['cityState'],
      zipCode: map['zipCode'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      annualSalesRevenue: map['annualSalesRevenue']?.toDouble(),
      annualCostOfGoodsSold: map['annualCostOfGoodsSold']?.toDouble(),
      annualFixedExpenses: map['annualFixedExpenses']?.toDouble(),
      overheadRatio: map['overheadRatio']?.toDouble(),
      company: map['company'] != null ? Company.fromMap(map['company']) : null,
    );
  }
}
