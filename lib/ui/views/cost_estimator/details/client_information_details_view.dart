import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/details/client_information_details_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ClientInformationDetailsView extends StatelessWidget {
  const ClientInformationDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ClientInformationDetailsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppFormField(
              enabled: model.enableFields,
              controller: model.nameController,
              label: 'Name',
              keyboardType: TextInputType.text,
              autofillHints: const [AutofillHints.organizationName],
            ),
            AppFormField(
              enabled: model.enableFields,
              controller: model.contactNameController,
              label: 'Contact person',
              keyboardType: TextInputType.name,
              autofillHints: const [AutofillHints.name],
            ),
            AppFormField(
              enabled: model.enableFields,
              controller: model.addressController,
              label: 'Address',
              keyboardType: TextInputType.streetAddress,
              autofillHints: const [AutofillHints.fullStreetAddress],
            ),
            AppFormField(
              enabled: model.enableFields,
              controller: model.cityStateController,
              label: 'City/State',
              keyboardType: TextInputType.text,
              autofillHints: const [AutofillHints.addressCityAndState],
            ),
            AppFormField(
              enabled: model.enableFields,
              controller: model.zipController,
              label: 'ZIP code',
              keyboardType: TextInputType.number,
              autofillHints: const [AutofillHints.postalCode],
            ),
            AppFormField(
              enabled: model.enableFields,
              controller: model.phoneController,
              label: 'Phone number',
              keyboardType: TextInputType.phone,
              autofillHints: const [AutofillHints.telephoneNumber],
            ),
            AppFormField(
              enabled: model.enableFields,
              controller: model.emailController,
              label: 'Email address',
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            if (model.isBusy) const LoadingButton(),
            if (!model.isBusy)
              AppFormButton(
                child: const Text('Save'),
                onPressed: model.onUpdate,
              ),
          ],
        ),
      ),
      viewModelBuilder: () => ClientInformationDetailsViewModel(),
    );
  }
}
