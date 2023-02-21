import 'package:flutter/material.dart';

class SuccessMessage extends StatelessWidget {
  final String message;

  const SuccessMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      color: Colors.greenAccent,
      child: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
