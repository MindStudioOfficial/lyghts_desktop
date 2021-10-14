import 'dart:convert';
import 'dart:io';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/utils.dart';

Future<bool> saveProject(Project project) async {
  Directory projectsDir = globalSettings.projectsDir;
  if (!projectsDir.existsSync()) {
    projectsDir.createSync(recursive: true);
  }
  File projectFile =
      File.fromUri(Uri.file(projectsDir.path + "/${project.filename.toLowerCase().replaceAll(" ", "_")}.lypr"));
  project.lastUpdatedAt = DateTime.now();

  projectFile.writeAsStringSync(jsonEncode(project.toJSON()));
  return true;
}

bool savePlan(Plan plan) {
  if (localProjects.any(
    (project) => project.plans.any(
      (p) {
        return p.uuid == plan.uuid;
      },
    ),
  )) {
    saveProject(
      localProjects.firstWhere(
        (project) => project.plans.any((p) => p.uuid == plan.uuid),
      ),
    );

    return true;
  }
  return false;
}

Future<bool> projectFilenameExists(String filename) async {
  Directory lyghtsDir = globalSettings.lyghtsDir;
  File projectFile = File.fromUri(Uri.file(lyghtsDir.path + "/${filename.toLowerCase().replaceAll(" ", "_")}.lypr"));
  if (projectFile.existsSync()) {
    return true;
  } else {
    return false;
  }
}

Future<List<Project>> loadProjects() async {
  List<Project> projects = [];
  Directory projectsDir = globalSettings.projectsDir;
  if (!projectsDir.existsSync()) projectsDir.createSync(recursive: true);
  List<FileSystemEntity> fse = projectsDir.listSync();
  for (FileSystemEntity element in fse) {
    if (element is File && element.path.split(".").last == "lypr") {
      String fileContent = element.readAsStringSync();
      if (jsonDecode(fileContent)['version'] != null) {
        projects.add(Project.fromJSON(jsonDecode(fileContent)));
      }
    }
  }
  return projects;
}
