import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/ui/widgets/subtitle.dart';

class MetricCard extends StatefulWidget {
  const MetricCard(
      {Key? key,
      required this.title,
      required this.value,
      this.highlight = false,
      this.isEditable = false,
      this.onChanged,
      this.height})
      : assert((isEditable && onChanged != null) || !isEditable),
        super(key: key);
  final String title;
  final String value;
  final bool isEditable;
  final Function(String)? onChanged;
  final double? height;
  final bool highlight;

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }
  
  @override
  Widget build(BuildContext context) {
    Widget valueWidget = Text(
      widget.value,
      style: const TextStyle(fontSize: 20),
    );
    if (widget.isEditable) {
      valueWidget = TextField(
        onChanged: widget.onChanged,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(doubleRegex),
        ],
        controller: _controller,
        style: const TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
        decoration: const InputDecoration(suffix: Icon(Icons.edit)),
      );
    }

    return Card(
      child: Container(
        color: widget.highlight ? Colors.amber[200] : null,
        height: widget.height,
        width: widget.isEditable ? 220 : null,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Subtitle(title: widget.title),
            const SizedBox(
              height: 10,
            ),
            valueWidget
          ],
        ),
      ),
    );
  }
}
