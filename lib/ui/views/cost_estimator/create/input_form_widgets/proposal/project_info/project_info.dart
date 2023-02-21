import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/util/validators.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/project_info_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ProjectInfoView extends StatelessWidget {
  const ProjectInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProjectInfoViewModel>.reactive(
      builder: (context, model, child) => Form(
        key: model.proposalSheetFormService.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppFormField(
              controller: model.proposalSheetFormService.projectNameController,
              label: 'Project Name',
              keyboardType: TextInputType.text,
              validator: vRequired,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            AppFormField(
              controller:
                  model.proposalSheetFormService.projectNumberController,
              label: 'Project Number',
              keyboardType: TextInputType.text,
            ),
            AppFormField(
              controller:
                  model.proposalSheetFormService.jobDescriptionController,
              label: 'Project Description',
              keyboardType: TextInputType.name,
            ),
            AppFormField(
              controller: model.proposalSheetFormService.jobLocationController,
              label: 'Project Location',
              keyboardType: TextInputType.name,
              autofillHints: const [
                AutofillHints.addressCityAndState,
              ],
            ),
          ],
        ),
      ),
      viewModelBuilder: () => ProjectInfoViewModel(),
    );
  }
}
