import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';
import 'package:stacked/stacked.dart';

class InputFormEditViewModel extends BaseViewModel {
  final _projectDetailService = locator<ProjectDetailService>();
  final _costEstimatorFormService = locator<CostEstimatorFormService>();
  final _proposalSheetFormService = locator<ProposalSheetFormService>();
  final _dialogService = locator<DialogService>();

  Project? get project => _projectDetailService.project;

  int _currentStep = 0;
  int get currentStep => _currentStep;
  int stepsAmount = 3;

  onModelReady() {
    _costEstimatorFormService.loadForEdit(project: project!);
    _proposalSheetFormService.loadForEdit(project: project!);
  }

  onStepTapped(int value) {
    _currentStep = value;
    notifyListeners();
  }

  void next() {
    _currentStep < stepsAmount - 1 ? _currentStep += 1 : null;
    notifyListeners();
  }

  back() {
    _currentStep > 0 ? _currentStep -= 1 : null;
    notifyListeners();
  }

  Future<void> onSubmit() async {
    Project? project =
        await _costEstimatorFormService.submitForm(isCreate: false);
    _dialogService.showConfirmationDialog(
        title: 'Success',
        description: 'Estimation successfully updated',
        showConfirmButton: false,
        cancelTitle: 'Accept');
    _projectDetailService.initialize(project: project);
  }

  onDispose() {
    _costEstimatorFormService.dispose();
  }
}
