import 'package:flutter/material.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/dialog_model.dart';
import 'package:mpg_mobile/services/dialog_service.dart';

class DialogManager extends StatefulWidget {
  final Widget? child;
  const DialogManager({Key? key, this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0xfffafafa),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.4,
                      ),
                      child: Text(request.title)),
                  IconButton(
                    onPressed: () {
                      _dialogService
                          .dialogComplete(DialogResponse(confirmed: false));
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              content: request.content,
              actions: request.showConfirmButton
                  ? <Widget>[
                      if (isConfirmationDialog)
                        TextButton(
                          child: Text(request.cancelTitle!),
                          onPressed: () {
                            _dialogService.dialogComplete(
                                DialogResponse(confirmed: false));
                          },
                        ),
                      TextButton(
                        child: Text(request.buttonTitle),
                        onPressed: () {
                          _dialogService
                              .dialogComplete(DialogResponse(confirmed: true));
                        },
                      ),
                    ]
                  : [],
            ));
  }
}
