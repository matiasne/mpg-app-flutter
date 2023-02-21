import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/models/financtial_indicator.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/models/non_financtial_indicator.dart';
import 'package:mpg_mobile/models/profit_statement.dart';
import 'package:mpg_mobile/viewmodels/business_valuation/create/profit_and_loss_statement_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:mpg_mobile/extensions/string_extensions.dart';

// this service serves as a sharing state for business valuation
// input form. (Business valuation create).
class BusinessValuationCreateService with ReactiveServiceMixin {
  TextEditingController nameController = TextEditingController();

  ReactiveValue<double> _revenue = ReactiveValue<double>(0);
  ReactiveValue<double> _revenueGrowth = ReactiveValue<double>(0);
  ReactiveValue<double> _ebitda = ReactiveValue<double>(0);
  ReactiveValue<double> _cogs = ReactiveValue<double>(0);

  double get revenue => _revenue.value;
  double get revenueGrowth => _revenueGrowth.value;
  double get ebitda => _ebitda.value;
  double get cogs => _cogs.value;

  DateTime? _loanStartDate;
  TextEditingController financtialRevenueController =
      TextEditingController(text: "0");
  TextEditingController financtialEBITDAController =
      TextEditingController(text: "0");
  TextEditingController financtialSDIController =
      TextEditingController(text: "0");
  TextEditingController financtialRevenueGrowthController =
      TextEditingController(text: "0");
  TextEditingController financtialEBITDAGrowthController =
      TextEditingController(text: "0");
  TextEditingController financtialSDIGrowthController =
      TextEditingController(text: "0");

  TextEditingController yearsController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController downPaymentController = TextEditingController();
  TextEditingController loanStartDateController = TextEditingController();

  bool shouldAddLoan = false;

  Map<String, ProfitStatementMetric> _profitStatementMetrics = {};

  List<NonFinanctialIndicatorInput> nonFinanctialIndicators = [
    NonFinanctialIndicatorInput(name: 'Good Financials'),
    NonFinanctialIndicatorInput(name: 'Good Team'),
    NonFinanctialIndicatorInput(name: 'Good processes / systems'),
    NonFinanctialIndicatorInput(name: 'Business Model'),
    NonFinanctialIndicatorInput(name: 'Technology / IT'),
    NonFinanctialIndicatorInput(name: 'Strong customer base'),
    NonFinanctialIndicatorInput(name: 'Brand awareness / Competition'),
  ];

  BusinessValuationCreateService() {
    listenToReactiveValues([
      _revenue,
      _ebitda,
      _cogs,
      _revenueGrowth,
    ]);
  }

  setRevenue(double? value) {
    if (value == null) return;
    _revenue.value = value;
  }

  setRevenueGrowth(double? value) {
    if (value == null) return;
    _revenueGrowth.value = value;
  }

  setEBITDA(double? value) {
    if (value == null) return;
    _ebitda.value = value;
  }

  setCOGS(double? value) {
    if (value == null) return;
    _cogs.value = value;
  }

  List<FinanctialIndicator> getFinanctialIndicators() {
    return [
      FinanctialIndicator(
        name: 'Revenue',
        year: DateTime.now().year,
        amount: financtialRevenueController.text.isNotEmpty
            ? financtialRevenueController.text.parseDouble()
            : 0,
        projectedGrowth: financtialRevenueGrowthController.text.isNotEmpty
            ? financtialRevenueGrowthController.text.parseDouble()
            : 0,
      ),
      FinanctialIndicator(
        name: 'EBITDA',
        year: DateTime.now().year,
        amount: financtialEBITDAController.text.isNotEmpty
            ? financtialEBITDAController.text.parseDouble()
            : 0,
        projectedGrowth: financtialEBITDAGrowthController.text.isNotEmpty
            ? financtialEBITDAGrowthController.text.parseDouble()
            : 0,
      ),
      FinanctialIndicator(
        name: 'SDI',
        year: DateTime.now().year,
        amount: financtialSDIController.text.isNotEmpty
            ? financtialSDIController.text.parseDouble()
            : 0,
        projectedGrowth: financtialSDIGrowthController.text.isNotEmpty
            ? financtialSDIGrowthController.text.parseDouble()
            : 0,
      ),
    ];
  }

  void setProfitStatementMetrics({
    required Map<String, ProfitStatementMetric> metrics,
  }) {
    _profitStatementMetrics = metrics;
  }

  List<ProfitStatement> getProfitStatements() {
    List<ProfitStatement> statements = [];
    for (var name in _profitStatementMetrics.keys) {
      statements.add(ProfitStatement(
          name: name,
          current: _profitStatementMetrics[name]!.current,
          projected: _profitStatementMetrics[name]!.projected));
    }
    return statements;
  }

  List<NonFinanctialIndicator> getNonFinanctialIndicators() {
    return nonFinanctialIndicators
        .map((nfi) => NonFinanctialIndicator(
              name: nfi.name,
              weight: int.tryParse(nfi.weightController.text) ?? 1,
              ranking: int.tryParse(nfi.rankingController.text) ?? 1,
            ))
        .toList();
  }

  void setLoanStartDate(DateTime date) {
    _loanStartDate = date;
  }

  Loan? getLoan() {
    if (!shouldAddLoan) return null;

    int years = int.tryParse(yearsController.text) ?? 1;
    double amount = amountController.text.isNotEmpty
        ? amountController.text.parseDouble()
        : 0;
    double downPayment = downPaymentController.text.isNotEmpty
        ? downPaymentController.text.parseDouble()
        : 0;
    double loanAmount = amount - downPayment;

    return Loan(
        numberOfYears: years,
        amount: amount,
        downPayment: downPayment,
        loanAmount: loanAmount,
        startDate: _loanStartDate ?? DateTime.now());
  }

  dispose() {
    financtialRevenueController = TextEditingController(text: "0");
    financtialEBITDAController = TextEditingController(text: "0");
    financtialSDIController = TextEditingController(text: "0");
    financtialRevenueGrowthController = TextEditingController(text: "0");
    financtialEBITDAGrowthController = TextEditingController(text: "0");
    financtialSDIGrowthController = TextEditingController(text: "0");
    yearsController = TextEditingController();
    amountController = TextEditingController();
    downPaymentController = TextEditingController();
    loanStartDateController = TextEditingController();
    nameController = TextEditingController();
    _revenue = ReactiveValue<double>(0);
    _revenueGrowth = ReactiveValue<double>(0);
    _ebitda = ReactiveValue<double>(0);
    _cogs = ReactiveValue<double>(0);
    _profitStatementMetrics = {};
    nonFinanctialIndicators = [
      NonFinanctialIndicatorInput(name: 'Good Financials'),
      NonFinanctialIndicatorInput(name: 'Good Team'),
      NonFinanctialIndicatorInput(name: 'Good processes / systems'),
      NonFinanctialIndicatorInput(name: 'Business Model'),
      NonFinanctialIndicatorInput(name: 'Technology / IT'),
      NonFinanctialIndicatorInput(name: 'Strong customer base'),
      NonFinanctialIndicatorInput(name: 'Brand awareness / Competition'),
    ];
  }
}

class NonFinanctialIndicatorInput {
  String name;
  TextEditingController weightController = TextEditingController();
  TextEditingController rankingController = TextEditingController();

  NonFinanctialIndicatorInput({required this.name});
}
