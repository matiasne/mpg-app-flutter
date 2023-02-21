import 'package:flutter/material.dart';
import 'package:mpg_mobile/dtos/client.dart';
import 'package:mpg_mobile/dtos/project.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/company.dart';
import 'package:mpg_mobile/models/cost_estimator_form.dart';
import 'package:mpg_mobile/models/labor_cost.dart';
import 'package:mpg_mobile/models/material_cost.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/api/cost_estimator_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';

class CostEstimatorFormService {
  final _costEstimatorService = locator<CostEstimatorService>();
  final _authenticationService = locator<AuthenticationService>();
  final _proposalFormService = locator<ProposalSheetFormService>();

  // General balance controllers
  TextEditingController revenueController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController expensesController = TextEditingController();
  TextEditingController ratioController = TextEditingController();

  ClientInfoDTO? _clientInfo;
  ProjectInfoDTO? _projectInfo;
  ProjectProposalInfoDTO? _projectProposalInfo;
  int? _projectId;
  int? _clientId;

  List<LaborCost> _laborCosts = [];
  List<LaborCost> get laborCosts => _laborCosts;
  List<MaterialCost> _materialCosts = [];
  List<MaterialCost> get materialCosts => _materialCosts;
  TextEditingController taxRatioController = TextEditingController();
  TextEditingController fringeRateController = TextEditingController();
  TextEditingController contingencyRatioController = TextEditingController();
  TextEditingController salesComissionController = TextEditingController();
  TextEditingController desiredProfitController = TextEditingController();
  TextEditingController squareFeetController = TextEditingController();

  loadForEdit({required Project project}) {
    _projectId = project.id;
    _clientId = project.client?.id;
    revenueController = TextEditingController(
        text: project.client!.annualSalesRevenue.toString());
    costController = TextEditingController(
        text: project.client!.annualCostOfGoodsSold.toString());
    expensesController = TextEditingController(
        text: project.client!.annualFixedExpenses.toString());
    ratioController =
        TextEditingController(text: project.client!.overheadRatio.toString());

    _laborCosts = project.laborCosts;
    _materialCosts = project.materialCosts;
    taxRatioController =
        TextEditingController(text: project.taxRatio.toString());
    fringeRateController =
        TextEditingController(text: project.fringeRate.toString());
    contingencyRatioController =
        TextEditingController(text: project.contingencyRate.toString());
    salesComissionController =
        TextEditingController(text: project.salesComission.toString());
    desiredProfitController =
        TextEditingController(text: project.desiredProfit.toString());
    squareFeetController =
        TextEditingController(text: project.squareFeet.toString());

    ProjectInfoDTO projectInfoDTO = ProjectInfoDTO(
        name: project.name,
        number: project.number,
        jobDescription: project.jobDescription,
        jobLocation: project.jobLocation);

    ProjectProposalInfoDTO projectProposalInfoDTO = ProjectProposalInfoDTO(
        objectives: project.objectives,
        scopes: project.scopes,
        keyAssumptions: project.keyAssumptions,
        startDate: project.startDate,
        endDate: project.endDate,
        weekHours: project.weekHours);

    setProjectInfo(projectInfoDTO);
    setProjectProposalInfo(projectProposalInfoDTO);
  }

  setClientInfo(ClientInfoDTO client) {
    _clientInfo = client;
  }

  setProjectInfo(ProjectInfoDTO project) {
    _projectInfo = project;
  }

  setProjectProposalInfo(ProjectProposalInfoDTO projectInfo) {
    _projectProposalInfo = projectInfo;
  }

  addMaterialCost(MaterialCost mc) {
    _materialCosts.add(mc);
  }

  removeMaterialCost(int index) {
    _materialCosts.removeAt(index);
  }

  addLaborCost(LaborCost lc) {
    _laborCosts.add(lc);
  }

  removeLaborCost(int index) {
    _laborCosts.removeAt(index);
  }

  Future<Project?> submitForm({bool isCreate = true}) async {
    if (!_proposalFormService.formKey.currentState!.validate()) {
      throw 'invalid form';
    }
    User? user = await _authenticationService.currentUser;
    if (user == null) return null;
    Company company = user.company!;

    Client client = Client(
        id: _clientInfo?.id ?? _clientId,
        name: _clientInfo?.name ?? '',
        contactName: _clientInfo?.contactName ?? '',
        address: _clientInfo?.address ?? '',
        cityState: _clientInfo?.cityState ?? '',
        zipCode: _clientInfo?.zipCode ?? '',
        email: _clientInfo?.email ?? '',
        phoneNumber: _clientInfo?.phoneNumber ?? '',
        annualSalesRevenue: double.parse(revenueController.text),
        annualCostOfGoodsSold: double.parse(costController.text),
        annualFixedExpenses: double.parse(expensesController.text),
        overheadRatio: double.parse(ratioController.text),
        company: company);

    Project project = Project(
        id: _projectId,
        name: _projectInfo!.name,
        number: _projectInfo!.number,
        startDate: _projectProposalInfo!.startDate!,
        endDate: _projectProposalInfo!.endDate!,
        jobDescription: _projectInfo!.jobDescription,
        jobLocation: _projectInfo!.jobLocation,
        contingencyRate: contingencyRatioController.text.isEmpty
            ? 0
            : double.parse(contingencyRatioController.text),
        desiredProfit: desiredProfitController.text.isEmpty
            ? 0
            : double.parse(desiredProfitController.text),
        fringeRate: fringeRateController.text.isEmpty
            ? 0
            : double.parse(fringeRateController.text),
        laborCosts: laborCosts,
        taxRatio: taxRatioController.text.isEmpty
            ? 0
            : double.parse(taxRatioController.text),
        squareFeet: squareFeetController.text.isEmpty
            ? 0
            : double.parse(squareFeetController.text),
        salesComission: salesComissionController.text.isEmpty
            ? 0
            : double.parse(salesComissionController.text),
        materialCosts: materialCosts,
        objectives: _projectProposalInfo!.objectives,
        scopes: _projectProposalInfo!.scopes,
        keyAssumptions: _projectProposalInfo!.keyAssumptions,
        weekHours: _projectProposalInfo!.weekHours);
    CostEstimatorForm costEstimatorForm = CostEstimatorForm(
      client: client,
      company: company,
      project: project,
    );

    if (isCreate) {
      await _costEstimatorService.createCostEstimation(costEstimatorForm);
      return null;
    } else {
      Project? result = await _costEstimatorService.patchByProjectId(
          projectId: _projectId!, form: costEstimatorForm);
      return result;
    }
  }

  dispose() {
    revenueController = TextEditingController();
    costController = TextEditingController();
    expensesController = TextEditingController();
    ratioController = TextEditingController();
    _projectId = null;
    _clientInfo = null;
    _projectInfo = null;
    _projectProposalInfo = null;
    _laborCosts = [];
    _materialCosts = [];
    taxRatioController = TextEditingController();
    fringeRateController = TextEditingController();
    contingencyRatioController = TextEditingController();
    salesComissionController = TextEditingController();
    desiredProfitController = TextEditingController();
    squareFeetController = TextEditingController();
    _proposalFormService.dispose();
  }
}
