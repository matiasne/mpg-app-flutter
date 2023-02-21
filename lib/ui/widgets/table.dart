import 'package:flutter/material.dart';

class AppTableRow {
  final List<DataCell> cells;
  final bool isHighlighted;
  final bool isPlaydown;
  AppTableRow({
    required this.cells,
    this.isHighlighted = false,
    this.isPlaydown = false,
  }) : assert(!isHighlighted || !isPlaydown,
            'if is highlighted cannot be playdown and vice-versa');
}

class AppTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<AppTableRow> rows;
  final AppTableRow? lastRow;
  const AppTable(
      {Key? key, required this.columns, required this.rows, this.lastRow})
      : super(key: key);

  _getColorByIndex(int index, BuildContext context) {
    return MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.08);
      }
      if (index.isEven) {
        return Colors.grey.withOpacity(0.2);
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> _rows = List<DataRow>.generate(
      rows.length,
      (int index) => DataRow(
        color: !rows[index].isHighlighted
            ? _getColorByIndex(index, context)
            : MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) => Colors.red[200]),
        cells: rows[index].cells,
      ),
    );

    if (lastRow != null) {
      _rows.add(DataRow(
        color: _getColorByIndex(rows.length, context),
        cells: lastRow!.cells,
      ));
    }

    return DataTable(
      columnSpacing: 20.0,
      columns: columns,
      rows: _rows,
    );
  }
}
