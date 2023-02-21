import 'package:flutter/material.dart';

class InfoMessage extends StatefulWidget {
  final String message;
  final Color textColor;

  const InfoMessage(
      {Key? key, required this.message, this.textColor = Colors.black})
      : super(key: key);

  @override
  State<InfoMessage> createState() => _InfoMessageState();
}

class _InfoMessageState extends State<InfoMessage> {
  bool _visible = false;

  toggle() => setState(() => _visible = !_visible);

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton.icon(
          icon: const Icon(Icons.info_outlined),
          label: const Text('More Info'),
          onPressed: toggle,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      color: Colors.blue[100],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: toggle,
                  icon: Icon(
                    Icons.close,
                    color: widget.textColor,
                  )),
            ],
          ),
          Text(
            widget.message,
            style: TextStyle(color: widget.textColor),
          ),
        ],
      ),
    );
  }
}
