import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mpg_mobile/models/dialog_model.dart';

class DialogService {
  final GlobalKey<NavigatorState> _dialogNavigationKey =
      GlobalKey<NavigatorState>();
  Function(DialogRequest)? _showDialogListener;
  Completer<DialogResponse>? _dialogCompleter;

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future<DialogResponse> showDialog({
    required String title,
    required Widget content,
    String buttonTitle = 'Ok',
    bool showConfirmButton = true,
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener!(DialogRequest(
      title: title,
      content: content,
      buttonTitle: buttonTitle,
      showConfirmButton: showConfirmButton,
    ));
    return _dialogCompleter!.future;
  }

  /// Shows a confirmation dialog
  Future<DialogResponse> showConfirmationDialog(
      {required String title,
      required String description,
      String confirmationTitle = 'Ok',
      String cancelTitle = 'Cancel',
      bool showConfirmButton = true}) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener!(DialogRequest(
        title: title,
        content: Text(description),
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle,
        showConfirmButton: showConfirmButton));
    return _dialogCompleter!.future;
  }

  // /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(DialogResponse response) {
    _dialogNavigationKey.currentState!.pop();
    _dialogCompleter!.complete(response);
    _dialogCompleter = null;
  }
}
