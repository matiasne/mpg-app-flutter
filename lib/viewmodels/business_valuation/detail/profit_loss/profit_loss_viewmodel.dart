import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/services/ui/business_valuation/profit_loss_service.dart';
import 'package:stacked/stacked.dart';

class ProfitLossViewModel extends BaseViewModel {
  final _profitLossService = locator<ProfitLossService>();

  Map<int, ProjectionType> typeof = {
    0: ProjectionType.projected,
    1: ProjectionType.revised,
  };

  onTabChanged(int val) => _profitLossService.switchProjectionType(type: typeof[val]!);
}