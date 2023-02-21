import 'package:mpg_mobile/constants/environments.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/user.dart';
import 'package:mpg_mobile/services/api/api.dart';
import 'package:mpg_mobile/services/authentication_service.dart';
import 'package:mpg_mobile/services/stripe_service.dart';

class PaymentsService extends Api {
  PaymentsService({required Environments environment})
      : super(environment: environment);

  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Future<String> getCheckoutUrl({required Plan plan}) async {
    User? user = await _authenticationService.currentUser;

    String esheetsPrice = 'price_1KRdO2LGUtEJqZO9JmJ6msj7';
    String costEstimatorPrice = 'price_1KRdNBLGUtEJqZO9UFN4KDRf';

    if (environment == Environments.prod) {
      esheetsPrice = 'price_1Kr0t0F7FI0f7zEKRKMCTY6d';
      costEstimatorPrice = 'price_1Kr0vTF7FI0f7zEKnggVZc5D';
    }

    String pricePlanId =
        plan == Plan.sheetsForSmallBusiness ? esheetsPrice : costEstimatorPrice;
    var url = Uri.parse(
      getEndpoint() +
          ApiRoutes.payments +
          '/createSession/${user!.id.toString()}/$pricePlanId',
    );

    var response = await client.get(
      url,
      headers: headers,
    );
    return response.body;
  }
}
