import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';
import 'package:mpg_mobile/viewmodels/auth/password_reset_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/form_field.dart';

class PasswordResetView extends StatelessWidget {
  final String? token;
  const PasswordResetView({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordResetViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(token: token),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Column(children: [
            if (model.isBusy) const CircularProgressIndicator(),
            if (!model.isBusy)
              Form(
                key: model.formKey,
                child: Column(
                  children: [
                    const Subtitle(title: 'Password Reset'),
                    AppFormField(
                      label: 'New Password',
                      obscureText: true,
                      controller: model.newPass,
                      validator: model.requiredValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    AppFormField(
                      controller: model.repeatPass,
                      label: 'Repeat new Password',
                      obscureText: true,
                      validator: model.equalPassValidator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    if (model.errorMsg.isNotEmpty)
                      ErrorMessage(message: model.errorMsg),
                    AppFormButton(
                        child: const Text('Reset Password'),
                        onPressed: model.onSubmit)
                  ],
                ),
              ),
          ]),
        ),
      ),
      viewModelBuilder: () => PasswordResetViewModel(),
    );
  }
}
