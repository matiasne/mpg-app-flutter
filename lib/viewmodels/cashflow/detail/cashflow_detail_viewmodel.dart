import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/cashflow.dart';
import 'package:mpg_mobile/services/api/cashflow_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_annualized_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_forecast_service.dart';
import 'package:stacked/stacked.dart';

class CashflowDetailViewModel extends BaseViewModel {
  final _cashflowApiService = locator<CashflowApiService>();
  final _navigatorService = locator<NavigationService>();
  final _cashflowForecastService = locator<CashflowForecastService>();
  final _annualizedService = locator<CashflowAnnualizedService>();

  String _title = 'Cashflow';
  String get title => _title;

  fetchCashflow({required int? id}) async {
    if (id == null) {
      goBack();
      return;
    }

    setBusy(true);
    CashFlow? _cashflow = await _cashflowApiService.getById(id: id);
    if (_cashflow == null) {
      goBack();
      return;
    }
    _title = _cashflow.name;
    _cashflowForecastService.initialize(cashflow: _cashflow);
    _annualizedService.initialize(cashflow: _cashflow);
    setBusy(false);
  }

  goBack() => _navigatorService.navigateTo(cashFlowRoute);
}
