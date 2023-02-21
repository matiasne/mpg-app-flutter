import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/customer_info.dart';
import 'package:mpg_mobile/services/api/cost_estimator_service.dart';


class CustomerInformationService {
  final _costEstimatorService = locator<CostEstimatorService>();

  Future<CustomerInformation> getCustomerInformation() async {
    return _costEstimatorService.getCustomerInfo();
  }
}