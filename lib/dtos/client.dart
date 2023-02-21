class ClientInfoDTO {
  int? id;
  String name;
  String contactName;
  String address;
  String cityState;
  String zipCode;
  String phoneNumber;
  String email;

  ClientInfoDTO({
    required this.id,
    required this.name,
    required this.contactName,
    required this.address,
    required this.cityState,
    required this.zipCode,
    required this.phoneNumber,
    required this.email,
  });
}

class ClientBalanceDTO {
  double annualSalesRevenue;
  double annualCostOfGoodsSold;
  double annualFixedExpenses;
  double overheadRatio;

  ClientBalanceDTO({
    required this.annualSalesRevenue,
    required this.annualCostOfGoodsSold,
    required this.annualFixedExpenses,
    required this.overheadRatio,
  });
}
