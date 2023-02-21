import 'package:mpg_mobile/constants/route_names.dart';
import 'package:mpg_mobile/locator.dart';
import 'package:mpg_mobile/models/project.dart';
import 'package:mpg_mobile/services/navigation_service.dart';
import 'package:mpg_mobile/services/api/project_service.dart';
import 'package:mpg_mobile/services/ui/cost_estimator/project_detail_service.dart';
import 'package:stacked/stacked.dart';

class ProjectDetailViewModel extends ReactiveViewModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final ProjectService _projectService = locator<ProjectService>();
  final ProjectDetailService _projectDetailService =
      locator<ProjectDetailService>();

  Project? _project;
  Project? get project => _project;

  String get title => _projectDetailService.projectName ?? 'Project details';

  onModelReady({required int? projectId}) {
    if (projectId == null) _onError();
    _loadProject(projectId: projectId!);
  }

  Future _loadProject({required int projectId}) async {
    setBusy(true);
    _project = await _projectService.getProjectById(id: projectId);
    if (_project == null) {
      _onError();
      return;
    }

    _projectDetailService.initialize(project: _project);
    setBusy(false);
  }

  onDispose() => _projectDetailService.dispose();

  goBack() => _navigationService.navigateTo(costEstimatorRoute);


  _onError() =>
    _navigationService.navigateTo(costEstimatorRoute);

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_projectDetailService];
}
