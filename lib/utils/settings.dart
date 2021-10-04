import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Map<String, dynamic> globalSettings = {};

void loadSettings() async {
  Directory appDir = await getApplicationSupportDirectory();
  Uri settingsUri = Uri.file(appDir.path + "/settings.json");
  File settingsFile = File.fromUri(settingsUri);
  if (!await settingsFile.exists()) {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory lyghtsDir = Directory.fromUri(Uri.directory(docDir.path + "/Lyghts"));
    Map<String, dynamic> settings = {
      'projectsPath': lyghtsDir.path,
    };
    settingsFile.writeAsStringSync(jsonEncode(settings));
  }

  String settingsJson = settingsFile.readAsStringSync();
  Map<String, dynamic> json = jsonDecode(settingsJson);
  globalSettings = json;
}
