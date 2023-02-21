import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
        height: 20,
        width: 20,
      ),
    );
  }
}
