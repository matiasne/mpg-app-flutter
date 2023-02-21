import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/client_information_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ClientInformationView extends StatelessWidget {
  final Function next;
  const ClientInformationView({Key? key, required this.next}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientInformationViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            model.loadingClients
                ? const CircularProgressIndicator()
                : AppFormSelectField(
                    label: model.clients != null && model.clients!.isNotEmpty
                        ? 'Client'
                        : 'No clients created',
                    items: model.clientOptions,
                    onChanged: model.onClientSelect,
                    value: model.selectedClientId,
                  ),
            Visibility(
              child: TextButton.icon(
                  onPressed: model.showForm,
                  icon: const Icon(Icons.add),
                  label: const Text('Create new Client')),
              visible: model.isCreateButtonVisible,
            ),
            Visibility(
              visible: model.isFormVisible,
              child: Column(
                children: [
                  AppFormField(
                    controller: model.businessNameController,
                    label: 'Business name',
                    keyboardType: TextInputType.text,
                    autofillHints: const [
                      AutofillHints.organizationName,
                    ],
                  ),
                  AppFormField(
                    controller: model.contactNameController,
                    label: 'Contact person',
                    keyboardType: TextInputType.name,
                    autofillHints: const [
                      AutofillHints.name,
                    ],
                  ),
                  AppFormField(
                    controller: model.addressController,
                    label: 'Address',
                    keyboardType: TextInputType.streetAddress,
                    autofillHints: const [
                      AutofillHints.fullStreetAddress,
                    ],
                  ),
                  AppFormField(
                    controller: model.cityStateController,
                    label: 'City/State',
                    keyboardType: TextInputType.text,
                    autofillHints: const [
                      AutofillHints.addressCityAndState,
                    ],
                  ),
                  AppFormField(
                    controller: model.zipController,
                    label: 'ZIP code',
                    keyboardType: TextInputType.number,
                    autofillHints: const [
                      AutofillHints.postalCode,
                    ],
                  ),
                  AppFormField(
                    controller: model.phoneController,
                    label: 'Phone number',
                    keyboardType: TextInputType.phone,
                    autofillHints: const [
                      AutofillHints.telephoneNumber,
                    ],
                  ),
                  AppFormField(
                    controller: model.emailController,
                    label: 'Email address',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.email,
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: model.onCancel,
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      model.isCreateClientButtonVisible
                          ? AppFormButton(
                              child: model.loadingClientCreate
                                  ? const SizedBox(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                      height: 20,
                                      width: 20,
                                    )
                                  : const Text('Create'),
                              onPressed: model.loadingClientCreate
                                  ? null
                                  : model.createClient)
                          : Container(),
                    ],
                  )
                ],
              ),
            ),
            Visibility(
              visible: model.noClientSelectedError,
              child: ErrorMessage(
                message: model.noClientSelectedErrorMsg,
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              buttonPadding: const EdgeInsets.all(20),
              children: [
                ElevatedButton(
                  onPressed: () async {
                    bool valid = await model.onSubmit();
                    if (valid) next();
                  },
                  child: const Text('Next'),
                )
              ],
            )
          ],
        ),
      ),
      viewModelBuilder: () => ClientInformationViewModel(),
    );
  }
}
