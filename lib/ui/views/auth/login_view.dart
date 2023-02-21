import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/viewmodels/auth/login_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../../locator.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Image(image:AssetImage('assets/logo.png')),
                  const Text('E-SHEETS',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:40,
                    color: Color(0xff112e15)
                    ),
                    ),
                    const Text('FINANCIAL TOOLS FOR SMALL BUSINESS OWERS',
                    textAlign:TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight:FontWeight.bold,
                      fontSize:18,
                      color: Color(0xcc112e15)
                      ),
                      maxLines: 2,
                    ),
                  Form(
                    key: model.formKey,
                    child: Column(
                      children: [
                        AppFormField(
                          controller: model.emailController,
                          label: 'Email',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => model.validateEmail(value),
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username,
                          ],
                        ),
                        AppFormField(
                          controller: model.passwordController,
                          label: 'Password',
                          obscureText: true,
                          autofillHints: const [
                            AutofillHints.password,
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Forgot your password',
                                style:const TextStyle(color: Color.fromARGB(255, 13, 108, 62)),
                                recognizer: TapGestureRecognizer()
                                    ..onTap = model.onPasswordReset
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: model.hasErrors,
                      child: ErrorMessage(
                        message: model.errorMessage,
                      )),
                  AppFormButton(
                    onPressed: model.isBusy ? null : model.onSubmit,
                    child: model.isBusy
                        ? const LoadingButton()
                        : const Text('Login',
                        ), 
                  /*      style: const  ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Color.fromARGB(255, 51, 153, 103) ),shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius:BorderRadius.only(
                            topRight: Radius.circular(18.0),
                            bottomRight: Radius.circular(18.0),
                            topLeft: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0)
                            )
                            ,
                        )),
                  ), */ 

                  ), RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Don´t have an account?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                  text: ' Sign Up',
                                  style: const TextStyle(color: Color.fromARGB(255, 96, 14, 1)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = model.toSignUp)
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
