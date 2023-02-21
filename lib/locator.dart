import 'package:get_it/get_it.dart';
import 'package:mpg_mobile/services/api/business_valuation_service.dart';
import 'package:mpg_mobile/services/api/cashflow_service.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/api/client_service.dart';
import 'package:mpg_mobile/services/api/company_service.dart';
import 'package:mpg_mobile/services/api/cost_estimator_service.dart';
import 'package:mpg_mobile/services/dialog_service.dart';
import 'package:mpg_mobile/services/download_mobile_service.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/api/payments_service.dart';
import 'package:mpg_mobile/services/api/project_service.dart';
import 'package:mpg_mobile/services/stripe_service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/business_valuation_create_service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/loan.service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/profit_loss_service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/projections.service.dart';
import 'package:mpg_mobile/services/ui/business_valuation/ranking_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_annualized_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_create_service.dart';
import 'package:mpg_mobile/services/ui/cashflow/cashflow_forecast_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:mpg_mobile/services/api/users_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/proposal_sheet_form.service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/cost_estinator_input_form.service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/customer_information.service.dart';
import 'package:mpg_mobile/services/web_platform_service.dart';
import 'constants/environments.dart';

GetIt locator = GetIt.instance;
const environment = Environments.localWeb;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => DialogService()); 

  // API services
  locator.registerLazySingleton(() => UsersService(environment: environment));
  locator.registerLazySingleton(
      () => CostEstimatorService(environment: environment));
  locator.registerLazySingleton(() => ClientService(environment: environment));
  locator.registerLazySingleton(() => CompanyService(environment: environment));
  locator.registerLazySingleton(() => ProjectService(environment: environment));
  locator
      .registerLazySingleton(() => PaymentsService(environment: environment));
  locator.registerLazySingleton(
      () => BusinessValuationApiService(environment: environment));
  locator.registerLazySingleton(
      () => CashflowApiService(environment: environment));

  // cost estimation
  locator.registerLazySingleton(() => CostEstimatorFormService());
  locator.registerLazySingleton(() => ProposalSheetFormService());
  locator.registerLazySingleton(() => CustomerInformationService());
  locator.registerLazySingleton(() => ProjectDetailService());
  locator.registerLazySingleton(() => WebPlatformService());
  locator.registerLazySingleton(() => MobilePlatformService());
  locator.registerLazySingleton(() => StripeService());

  // business valuation
  locator.registerLazySingleton(() => BusinessValuationCreateService());
  locator.registerLazySingleton(() => LoanService());
  locator.registerLazySingleton(() => ProjectionsService());
  locator.registerLazySingleton(() => RankingService());
  locator.registerLazySingleton(() => ProfitLossService());

  // cash flow
  locator.registerLazySingleton(() => CashFlowCreateService());
  locator.registerLazySingleton(() => CashflowForecastService());
  locator.registerLazySingleton(() => CashflowAnnualizedService());
}
