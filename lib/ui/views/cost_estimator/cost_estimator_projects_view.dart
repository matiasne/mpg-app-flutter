import 'package:flutter/material.dart';
import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/constants/utils.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/ui/widgets/form_select_field.dart';
import 'package:mpg_mobile/ui/widgets/title.dart';
import 'package:mpg_mobile/ui/widgets/tool_description_banner.dart';
import 'package:mpg_mobile/viewmodels/cost_estimator/cost_estimator_projects_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CostEstimatorProjectsView extends StatelessWidget {
  const CostEstimatorProjectsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CostEstimatorProjectsViewModel>.reactive(
      onModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) => Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                DescriptionBanner(
                  title: model.descriptionTitle,
                  fullDescription: model.fullDescription,
                  preview: model.preview,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: AppTitle(title: 'Projects'),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: model.loadProjects(),
                  builder: (context, AsyncSnapshot<List<Project>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    List<Project>? projects = <Project>[];
                    if (snapshot.data != null) {
                      projects = snapshot.data;
                    }

                    return Column(
                      children: [
                        AppFormSelectField(
                          label: 'Client',
                          items: model.clientsOptions,
                          onChanged: model.onClientSelect,
                          value: model.selectedClientId,
                        ),
                        ProjectsTableView(projects: projects)
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: model.create,
            label: const Text('Create'),
            icon: const Icon(Icons.add),
          )),
      viewModelBuilder: () => CostEstimatorProjectsViewModel(),
    );
  }
}

class ProjectsTableView extends StatelessWidget {
  final List<Project>? projects;
  const ProjectsTableView({Key? key, required this.projects}) : super(key: key);

  _toProjectDetail({required Project project}) {
    locator<NavigationService>().navigateTo(
      projectDetailRoute,
      queryParams: {'id': project.id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Client',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'Start Date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            label: Text(
              'End Date',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: projects == null
            ? []
            : projects!
                .map((p) => DataRow(
                      onSelectChanged: (bool? selected) {
                        if (selected != null && selected) {
                          _toProjectDetail(project: p);
                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(p.name)),
                        DataCell(Text(p.client != null ? p.client!.name : '')),
                        DataCell(Text(dateFormat.format(p.startDate))),
                        DataCell(Text(dateFormat.format(p.endDate))),
                      ],
                    ))
                .toList(),
      ),
    );
  }
}
