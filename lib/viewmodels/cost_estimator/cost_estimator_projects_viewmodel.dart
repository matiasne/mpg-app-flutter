import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/client.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/api/company_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/api/project_service.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:stacked/stacked.dart';

import '../../ui/widgets/tool_description_banner.dart';

class CostEstimatorProjectsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authenticationService = locator<AuthenticationService>();
  final _companyService = locator<CompanyService>();
  final _projectService = locator<ProjectService>();

  List<Project> _projects = [];
  List<Client?> _clients = [];

  final List<AppSelectOption> _clientsOptions = [];
  List<AppSelectOption> get clientsOptions => _clientsOptions;

  int _selectedClientId = 0;
  int? get selectedClientId => _selectedClientId;

  String descriptionTitle = 'Cost Estimator';
  List<DescriptionText> fullDescription = [
    DescriptionText(
        text:
            '\n\nCost estimators collect and analyze data in order to assess the time, money, materials, and labor '
            'required to manufacture a product, construct a building, or provide a service. They generally '
            'specialize in a particular product or industry.',
        isTitle: false),
    DescriptionText(text: 'Methodology', isTitle: true),
    DescriptionText(
        text:
            'nStep 1. Estimate the Total Cost of Goods Sold for a particular good or service or for a particular  job.   This  should  include  the  total  amount  of  direct  labor  (with  labor  burden), delivery  and  handling  costs,  equipment  time,  miscellaneous  expenses,  materials,  and  if needed any additional equipment rentals, etc.',
        isTitle: false),
    DescriptionText(
        text:
            '\nStep 2. Multiply this Total Cost of Goods Sold by  the Overhead Factor and add the resulting product to the Total Cost of Goods Sold amount.'
            '\nBasically, one can figure that for every dollar which is spent on Cost of Goods Sold, an additional amount "\$???" (Determined by the overhead factor) will be spent in General and Administrative Expense (Non-Direct Costs).'
            '\nFor example, referring to your P&L for 2021 and the results we find the following Costs of Goods and General & Administrative Expenses'
            '\n\nSales=\$2,000,000'
            '\nCost of Goods Sold=\$1,300,000'
            '\nGen. & Adm. Expense=\$500,000\n'
            '\nFor 2022 Budget, we would divide \$ 500,000 by \$ 1,300,000 which equals 0.3846 or expressed  as  a  percentage,  the  Overhead  Factor  would  be:  38.46%  or  rounded 38.5%.'
            '\n\nThis amount represents your total cost for the job or cost to Break Even.',
        isTitle: false),
    DescriptionText(
        text:
            'Step 3. The Price is finally determined after adding in contingency and profit.  This is calculated  by  multiplying  the  Break  Even  amount  by  [100%  +  contingency  percentage] and then dividing the result by [100% - targeted profit percentage].',
        isTitle: false),
    DescriptionText(
        text:
            'This amount represents your total selling price to maintain the desired profit margin. Compare this to your current estimating methods and rates indicates if the rates are adequate.',
        isTitle: false),
  ];

  String preview =
      'Cost estimators collect and analyze data in order to assess the time, money, materials, and labor '
      'required to manufacture a product, construct a building, or provide a service. They generally '
      'specialize in a particular product or industry.';

  onModelReady() {
    _loadClients();
  }

  Future<List<Project>> loadProjects() async {
    User? user = await _authenticationService.currentUser;
    if (user == null || user.company == null) return [];

    _projects = await _projectService.getProjectsByCompanyId(
      companyId: user.company!.id!,
    );

    if (_selectedClientId != 0) {
      _projects = _projects.where((p) {
        return p.client!.id == _selectedClientId;
      }).toList();
    }

    return _projects;
  }

  void onClientSelect(int? val) {
    if (val == null) return;
    _selectedClientId = val;
    notifyListeners();
  }

  Future _loadClients() async {
    User? user = await _authenticationService.currentUser;
    if (user == null || user.company == null) return;

    _clients = await _companyService.getClientsForCompany(
      companyId: user.company!.id!,
    );

    for (var c in _clients) {
      _clientsOptions.add(
        AppSelectOption(label: c!.name, value: c.id!),
      );
    }
    _clientsOptions.add(
      AppSelectOption(label: '-', value: 0),
    );
  }

  create() {
    _navigationService.navigateTo(createProjectRoute);
  }
}
