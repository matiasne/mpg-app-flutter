import 'package:mpg_mobile/dtos/project.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';
import 'package:stacked/stacked.dart';

import '../../../locator.dart';

class ProposalSheetViewModel extends BaseViewModel {
  final proposalSheetFormService = locator<ProposalSheetFormService>();
  final costEstimatorFormService = locator<CostEstimatorFormService>();

  String errorMsg = '';

  bool isLoadingCreate = false;

  setLoadingCreate(bool val) {
    isLoadingCreate = val;
    notifyListeners();
  }

  onSubmit() {
    bool isValid = true;
    errorMsg = '';
    notifyListeners();
    if (!proposalSheetFormService.formKey.currentState!.validate()) {
      errorMsg = 'Check required fields';
      isValid = false;
      notifyListeners();
      return isValid;
    }
    ProjectInfoDTO projectInfo = ProjectInfoDTO(
      name: proposalSheetFormService.projectNameController.text,
      jobDescription: proposalSheetFormService.jobDescriptionController.text,
      jobLocation: proposalSheetFormService.jobLocationController.text,
      number: proposalSheetFormService.projectNumberController.text,
    );

    ProjectProposalInfoDTO projectProposal = ProjectProposalInfoDTO(
      objectives: proposalSheetFormService.objectives,
      scopes: proposalSheetFormService.scopes,
      keyAssumptions: proposalSheetFormService.keyAssumptions,
      startDate: proposalSheetFormService.startDate,
      endDate: proposalSheetFormService.endDate,
      weekHours: proposalSheetFormService.weekHours,
    );

    costEstimatorFormService.setProjectInfo(projectInfo);
    costEstimatorFormService.setProjectProposalInfo(projectProposal);
    return isValid;
  }
}
