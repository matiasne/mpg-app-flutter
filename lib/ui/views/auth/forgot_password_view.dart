import 'package:flutter/material.dart';
import 'package:mpg_mobile/ui/widgets/error_message.dart';
import 'package:mpg_mobile/ui/widgets/form_button.dart';
import 'package:mpg_mobile/ui/widgets/form_field.dart';
import 'package:mpg_mobile/ui/widgets/loading_button.dart';
import 'package:mpg_mobile/ui/widgets/success_message.dart';
import 'package:mpg_mobile/viewmodels/auth/forgot_password_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotPasswordViewModel>.reactive(
      builder: (context, model, child) => Form(
        key: model.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxWidth: 400,
              ),
              child: Text(
                'Enter your email and we will send you an email for setting up a new password.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            AppFormField(
              label: 'Email',
              controller: model.emailController,
              validator: model.validateEmail,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            if (model.errorMsg.isNotEmpty)
              ErrorMessage(message: model.errorMsg),
            if (model.success) SuccessMessage(message: model.successMsg),
            model.isBusy
                ? const LoadingButton()
                : AppFormButton(
                    child: const Text('Send reset email'),
                    onPressed: model.onConfirm)
          ],
        ),
      ),
      viewModelBuilder: () => ForgotPasswordViewModel(),
    );
  }
}
