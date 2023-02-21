import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/business_valuation.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/services/api/business_valuation_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/profit_loss_service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/ranking_service.dart';
import 'package:stacked/stacked.dart';

class BusinessValuationDetailViewModel extends BaseViewModel {
  final _businessValuationApiService = locator<BusinessValuationApiService>();
  final _navigatorService = locator<NavigationService>();
  final _projectionsService = locator<ProjectionsService>();
  final _rankingService = locator<RankingService>();
  final _profitLossService = locator<ProfitLossService>();

  String _title = 'Business Valuation';
  String get title => _title;

  bool _hasLoan = false;
  bool get hasLoan => _hasLoan;

  Loan? _loan;
  Loan? get loan => _loan;

  fetchBusinessValuation({required int? id}) async {
    if (id == null) {
      goBack();
      return;
    }

    setBusy(true);
    BusinessValuation? _businessValuation =
        await _businessValuationApiService.getById(id: id);
    if (_businessValuation == null) {
      goBack();
      return;
    }
    _title = _businessValuation.businessName;
    _hasLoan = _businessValuation.loan != null;
    _loan = _businessValuation.loan;

    _projectionsService.initialize(businessValuation: _businessValuation);
    _rankingService.initialize(businessValuation: _businessValuation);
    _profitLossService.initialize(businessValuation: _businessValuation);
    setBusy(false);
  }

  goBack() => _navigatorService.navigateTo(businessValuationRoute);
}
