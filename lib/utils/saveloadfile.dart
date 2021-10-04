import 'dart:convert';
import 'dart:io';

import 'package:lyghts_desktop/models.dart';
import 'package:path_provider/path_provider.dart';

void saveProject(Project project) async {
  Directory docDir = await getApplicationDocumentsDirectory();
  Directory lyghtsDir = Directory.fromUri(Uri.directory(docDir.path + "/Lyghts"));
  if (!lyghtsDir.existsSync()) lyghtsDir.createSync();
  File projectFile =
      File.fromUri(Uri.file(lyghtsDir.path + "/${project.filename.toLowerCase().replaceAll(" ", "_")}.lypr"));

  projectFile.writeAsStringSync(jsonEncode(project.toJSON()));
}

Future<bool> projectFilenameExists(String filename) async {
  Directory docDir = await getApplicationDocumentsDirectory();
  Directory lyghtsDir = Directory.fromUri(Uri.directory(docDir.path + "/Lyghts"));
  File projectFile = File.fromUri(Uri.file(lyghtsDir.path + "/${filename.toLowerCase().replaceAll(" ", "_")}.lypr"));
  if (projectFile.existsSync()) {
    return true;
  } else {
    return false;
  }
}

Future<List<Project>> loadProjects() async {
  Directory d = await getApplicationSupportDirectory();
  print(d.path);

  List<Project> projects = [];
  Directory docDir = await getApplicationDocumentsDirectory();
  Directory lyghtsDir = Directory.fromUri(Uri.directory(docDir.path + "/Lyghts"));
  if (!lyghtsDir.existsSync()) lyghtsDir.createSync();
  List<FileSystemEntity> fse = lyghtsDir.listSync();
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
