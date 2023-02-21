class CompanyInfoDTO {
  String name;
  String contactName;
  String contactTitle;
  String businessAddress;
  String cityState;
  String zipCode;
  String phoneNumber;
  String? federalTaxId;

  CompanyInfoDTO({
    required this.name,
    required this.contactName,
    required this.contactTitle,
    required this.businessAddress,
    required this.cityState,
    required this.zipCode,
    required this.phoneNumber,
    required this.federalTaxId,
  });

}
