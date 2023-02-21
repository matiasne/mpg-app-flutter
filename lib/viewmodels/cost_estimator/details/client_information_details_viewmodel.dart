import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/services/api/client_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:stacked/stacked.dart';

import '../../../locator.dart';

class ClientInformationDetailsViewModel extends BaseViewModel {
  final ProjectDetailService _projectDetailService =
      locator<ProjectDetailService>();
  final ClientService _clientService = locator<ClientService>();
  Client? _client;

  TextEditingController nameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityStateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  bool get enableFields => true;

  onModelReady() {
    if (_projectDetailService.client == null) return;
    _client = _projectDetailService.client;

    nameController = TextEditingController(text: _client!.name);
    contactNameController = TextEditingController(text: _client!.contactName);
    addressController = TextEditingController(text: _client!.address);
    cityStateController = TextEditingController(text: _client!.cityState);
    zipController = TextEditingController(text: _client!.zipCode);
    phoneController = TextEditingController(text: _client!.phoneNumber);
    emailController = TextEditingController(text: _client!.email);
  }

  Future onUpdate() async {
    setBusy(true);

    Client client = Client(
      id: _client?.id,
      name: nameController.text,
      contactName: contactNameController.text,
      address: addressController.text,
      cityState: cityStateController.text,
      zipCode: zipController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
    );

    await _clientService.patch(client: client);
    setBusy(false);
  }
}
