import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/viewmodels/auth/payment_success_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PaymentSuccessViewModel>.reactive(
      onModelReady: (model) => model.refreshUser(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/success.png', height: 100),
              const SizedBox(height: 20),
              const Text('The payment was successful, Welcome to MPG'),
              const SizedBox(height: 20),
              AppFormButton(
                child: const Text('Accept'),
                onPressed: model.goDashboard,
              )
            ],
          ),
        ),
      ),
      viewModelBuilder: () => PaymentSuccessViewModel(),
    );
  }
}
