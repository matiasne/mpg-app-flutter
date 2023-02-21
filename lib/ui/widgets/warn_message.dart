import 'package:flutter/material.dart';

class WarnMessage extends StatelessWidget {
  final String message;

  const WarnMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      color: Colors.yellow[200],
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}