import 'package:flutter/material.dart';

class AppFormButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final ButtonStyle?style;
  const AppFormButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.style,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      constraints: const BoxConstraints(minHeight: 40),
      child: ElevatedButton(onPressed: onPressed, child: child ,style:style),
    );
  }
}
