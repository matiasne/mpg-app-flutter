import 'package:flutter/material.dart';
import 'package:mpg_mobile/dtos/client.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/api/client_service.dart';
import 'package:mpg_mobile/services/api/company_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:stacked/stacked.dart';

class ClientInformationViewModel extends BaseViewModel {
  final _clientService = locator<ClientService>();
  final _authenticationService = locator<AuthenticationService>();
  final _costEstimatorService = locator<CostEstimatorFormService>();
  final _companyService = locator<CompanyService>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController businessNameController = TextEditingController();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityStateController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  int? selectedClientId;
  List<Client>? clients;
  List<AppSelectOption> clientOptions = [];

  bool isFormVisible = false;
  bool isCreateButtonVisible = true;
  bool isCreateClientButtonVisible = true;
  bool loadingClients = false;
  bool loadingClientCreate = false;
  bool noClientSelectedError = false;

  String noClientSelectedErrorMsg = 'You must select a client';

  onModelReady() {
    loadClients();
  }

  onSubmit() {
    bool isValid = selectedClientId != null;
    if (!isValid) {
      noClientSelectedError = true;
      notifyListeners();
      return isValid;
    }

    ClientInfoDTO client = ClientInfoDTO(
      id: selectedClientId,
      name: businessNameController.text,
      contactName: contactNameController.text,
      address: addressController.text,
      cityState: cityStateController.text,
      zipCode: zipController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
    );
    _costEstimatorService.setClientInfo(client);
    return isValid;
  }

  showForm() {
    isFormVisible = true;
    isCreateButtonVisible = false;
    notifyListeners();
  }

  Future<bool> createClient() async {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) return isValid;

    User? user = await _authenticationService.currentUser;
    if (user == null) return isValid;

    loadingClientCreate = true;
    notifyListeners();

    Client newClient = Client(
      name: businessNameController.text,
      contactName: contactNameController.text,
      address: addressController.text,
      cityState: cityStateController.text,
      zipCode: zipController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
      company: user.company,
    );

    await _clientService.createClient(client: newClient);

    loadingClientCreate = false;
    isFormVisible = false;
    isCreateClientButtonVisible = true;
    loadClients();
    return isValid;
  }

  Future<void> loadClients() async {
    loadingClients = true;
    notifyListeners();

    User? user = await _authenticationService.currentUser;
    if (user == null) return;

    clients =
        await _companyService.getClientsForCompany(companyId: user.company!.id!);

    if (clients != null) {
      clientOptions = clients!
          .map((c) => AppSelectOption(value: c.id!, label: c.name))
          .toList();
    }

    loadingClients = false;
    notifyListeners();
  }

  onCancel() {
    businessNameController = TextEditingController();
    contactNameController = TextEditingController();
    addressController = TextEditingController();
    cityStateController = TextEditingController();
    zipController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    isFormVisible = false;
    isCreateButtonVisible = true;
    isCreateClientButtonVisible = true;
    selectedClientId = null;
    notifyListeners();
  }

  onClientSelect(int? id) {
    if (clients == null) return;

    Client client = clients!.firstWhere((c) => c.id == id);
    selectedClientId = id;

    businessNameController = TextEditingController(text: client.name);
    contactNameController = TextEditingController(text: client.contactName);
    addressController = TextEditingController(text: client.address);
    cityStateController = TextEditingController(text: client.cityState);
    zipController = TextEditingController(text: client.zipCode);
    phoneController = TextEditingController(text: client.phoneNumber);
    emailController = TextEditingController(text: client.email);

    isFormVisible = true;
    isCreateButtonVisible = false;
    isCreateClientButtonVisible = false;
    noClientSelectedError = false;
    notifyListeners();
  }

  String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'The field is required';
    }
    return null;
  }
}
