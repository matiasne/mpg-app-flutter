import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/create/proposal/labor_tracker_viewmodel.dart';
import 'package:stacked/stacked.dart';

class LaborTrackerView extends StatelessWidget {
  const LaborTrackerView({Key? key}) : super(key: key);

  final List<DataColumn> _weekHoursColumns = const <DataColumn>[
    DataColumn(
      label: Text(
        'Week ending',
        style: TextStyle(fontSize: 12),
      ),
    ),
    DataColumn(
      label: Text(
        'Billable labor hours',
        style: TextStyle(fontSize: 12),
      ),
      numeric: true,
    ),
  ];

  List<DataCell> _buildLastRow(double totalHours) {
    return <DataCell>[
      const DataCell(
        Text(
          'TOTAL LABOR HOURS ',
          style: TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      DataCell(
        Text(
          '$totalHours',
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LaborTrackerViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        model.generateSundayEntries(model.startDate, model.endDate);
        DataTable table = DataTable(
          columnSpacing: 20.0,
          columns: _weekHoursColumns,
          rows: List<DataRow>.generate(model.weekHours.length + 1, (int index) {
            if (index == model.weekHours.length) {
              return DataRow(
                cells: _buildLastRow(model.totalHours),
              );
            }
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    dateFormat.format(model.weekHours[index].day),
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DataCell(
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(doubleRegex),
                    ],
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    initialValue: model.weekHours[index].hours.toString(),
                    onChanged: (val) {
                      model.onChangeWeeklyHour(index, val);
                    },
                  ),
                  placeholder: true,
                ),
              ],
            );
          }),
        );

        return SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: table);
      },
      viewModelBuilder: () => LaborTrackerViewModel(),
    );
  }
}
