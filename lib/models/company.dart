class Company {
  int? id;
  String name;
  String contactName;
  String contactTitle;
  String businessAddress;
  String cityState;
  String zipCode;
  String phoneNumber;
  String? federalTaxId;

  Company({
    this.id,
    required this.name,
    required this.contactName,
    required this.contactTitle,
    required this.businessAddress,
    required this.cityState,
    required this.zipCode,
    required this.phoneNumber,
    this.federalTaxId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactName': contactName,
      'contactTitle': contactTitle,
      'businessAddress': businessAddress,
      'cityState': cityState,
      'zipCode': zipCode,
      'phoneNumber': phoneNumber,
      'federalTaxId': federalTaxId,
    };
  }

  static Company fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'],
      name: map['name'],
      contactName: map['contactName'],
      contactTitle: map['contactTitle'],
      businessAddress: map['businessAddress'],
      cityState: map['cityState'],
      zipCode: map['zipCode'],
      phoneNumber: map['phoneNumber'],
      federalTaxId: map['federalTaxId'],
    );
  }
}
