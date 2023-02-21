import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/dimensions.dart';
import 'package:mpg_mobile/ui/views/auth/signup_form_view.dart';
import 'package:mpg_mobile/ui/views/auth/signup_subscription_view.dart';
import 'package:mpg_mobile/viewmodels/auth/signup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) {
        List<Widget> stepContent = [
          SignupFormView(next: model.next),
          SignupSubscriptionView(),
        ];
        return Scaffold(
          // appBar: AppBar(
          //   leading: BackButton(
          //     onPressed: model.goHome,
          //   ),
          //   title: const Text('Create new account'),
          // ),
          body: SafeArea(
            child: Theme(
              data:ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: const Color.fromARGB(255, 51, 153, 103) ,
              ),
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: Dimensions.m),
                child: Stepper(
                  currentStep: model.currentStep,
                  onStepTapped: model.onStepTapped,
                  elevation: 0,
                  controlsBuilder:(context, details,) => Container(),
                  type: StepperType.horizontal,
                  steps: model.steps
                      .asMap()
                      .map((i, title) => MapEntry(
                          i,
                          Step(
                            isActive: i == model.currentStep,
                            title: Text(title),
                            content: stepContent[i],
                          )))
                      .values
                      .toList(),
                      
                      ),

              ),
              
            ),
          ),
        );
      },
      viewModelBuilder: () => SignUpViewModel(),
    );
  }
}
