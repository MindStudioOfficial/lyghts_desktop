import 'dart:convert';
import 'dart:io';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> saveProject(Project project) async {
  Directory docDir = await getApplicationDocumentsDirectory();
  Directory lyghtsDir = Directory.fromUri(Uri.directory(docDir.path + "/Lyghts"));
  if (!lyghtsDir.existsSync()) lyghtsDir.createSync();
  File projectFile =
      File.fromUri(Uri.file(lyghtsDir.path + "/${project.filename.toLowerCase().replaceAll(" ", "_")}.lypr"));

  projectFile.writeAsStringSync(jsonEncode(project.toJSON()));
  return true;
}

bool savePlan(Plan plan) {
  if (localProjects.any((project) => project.plans.any((p) => p == plan))) {
    saveProject(localProjects.firstWhere((project) => project.plans.any((p) => p == plan)));
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
  if (!projectsDir.existsSync()) projectsDir.createSync();
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
