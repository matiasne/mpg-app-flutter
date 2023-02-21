import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/loan.dart';
import 'package:mpg_mobile/services/ui/business_valuation/loan.service.dart';
import 'package:stacked/stacked.dart';

class LoanViewModel extends BaseViewModel {
  final _loanService = locator<LoanService>();

  onModelReady({required Loan? loan}) {
    if(loan == null) return;
    _loanService.initialize(loan: loan);
  }

  onDispose() {
    _loanService.dispose();
  }

}