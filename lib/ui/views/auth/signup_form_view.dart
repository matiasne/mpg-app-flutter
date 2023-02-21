import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/auth/signup_form_viewmodel.dart';
import 'package:stacked/stacked.dart';

class SignupFormView extends StatelessWidget {
  const SignupFormView({Key? key, required this.next}) : super(key: key);
  final Function() next;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignupFormViewModel>.reactive(
      builder: (context, model, child) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: model.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Subtitle(
                      title: 'User Information',
                    ),
                    AppFormField(
                      controller: model.emailController,
                      label: 'Email',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.validateEmail(value),
                      autofillHints: const [
                        AutofillHints.email,
                      ],
                    ),
                    AppFormField(
                      controller: model.passwordController,
                      label: 'Password',
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.validatePassword(value),
                      autofillHints: const [
                        AutofillHints.password,
                      ],
                    ),
                    const Subtitle(
                      title: 'Company Information',
                    ),
                    AppFormField(
                      controller: model.nameController,
                      label: 'Company Name',
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.organizationName,
                      ],
                    ),
                    AppFormField(
                      controller: model.contactNameController,
                      label: 'Contact Name',
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.name,
                      ],
                    ),
                    AppFormField(
                      controller: model.contactTitleController,
                      label: 'Contact Title',
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.jobTitle,
                      ],
                    ),
                    AppFormField(
                      controller: model.contactAddressController,
                      label: 'Business Address',
                      keyboardType: TextInputType.streetAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.fullStreetAddress,
                      ],
                    ),
                    AppFormField(
                      controller: model.cityStateController,
                      label: 'City/State',
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.addressCityAndState,
                      ],
                    ),
                    AppFormField(
                      controller: model.zipCodeController,
                      label: 'ZIP Code',
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.postalCode,
                      ],
                    ),
                    AppFormField(
                      controller: model.phoneNumberController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => model.required(value),
                      autofillHints: const [
                        AutofillHints.telephoneNumber,
                      ],
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
                  onPressed: model.isBusy
                      ? null
                      : () async {
                          await model.onSubmit();
                          if (!model.hasErrors) next();
                        },
                  child:
                   model.isBusy
                      ? const LoadingButton()
                      : const Text('SIGN UP')
                     /* ,style: const  ButtonStyle(backgroundColor:MaterialStatePropertyAll<Color>(Color.fromARGB(255, 51, 153, 103) ),shape: MaterialStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius:BorderRadius.only(
                            topRight: Radius.circular(18.0),
                            bottomRight: Radius.circular(18.0),
                            topLeft: Radius.circular(18.0),
                            bottomLeft: Radius.circular(18.0)
                            )
                            ,
                        )),
                  ),*/
                   
                  ),
                  RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Already have an acount',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                  text: ' Sign in',
                                  style: const TextStyle(color: Color.fromARGB(255, 96, 14, 1)),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = model.toLogIn)
                            ],
                          ),
                        ),
                  
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SignupFormViewModel(),
    );
  }
}
