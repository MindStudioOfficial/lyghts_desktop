import 'dart:convert';
import 'dart:io';

import 'package:lomp_desktop/models.dart';
import 'package:path_provider/path_provider.dart';

void saveProject(Project project) async {
  Directory docDir = await getApplicationDocumentsDirectory();
  String docDirPath = docDir.path;
  Directory lyghtsDir = Directory.fromUri(Uri.directory(docDirPath + "/Lyghts"));
  if (!lyghtsDir.existsSync()) lyghtsDir.createSync();
  File projectFile = File.fromUri(Uri.file(lyghtsDir.path + "/project.lypr"));
  if (!projectFile.existsSync()) {
    projectFile.writeAsStringSync(jsonEncode(project.toJSON()));
  }
}
