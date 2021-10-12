import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppSettings {
  Directory lyghtsDir;
  AppSettings({required this.lyghtsDir});

  Directory get exportsDir {
    return Directory.fromUri(Uri.directory(lyghtsDir.path + "/Exports"));
  }

  Directory get projectsDir {
    return Directory.fromUri(Uri.directory(lyghtsDir.path + "/Projects"));
  }

  Future<Directory> get applicationDir async {
    return await getApplicationSupportDirectory();
  }

  factory AppSettings.fromJSON(Map<String, dynamic> json) {
    return AppSettings(lyghtsDir: Directory.fromUri(Uri.directory(json['path_lyghts'])));
  }

  Map<String, dynamic> toJSON() {
    return {
      'path_lyghts': lyghtsDir.path,
    };
  }
}

late AppSettings globalSettings;

Future<Map<String, dynamic>> loadSettings() async {
  Directory appDir = await getApplicationSupportDirectory();
  Uri settingsUri = Uri.file(appDir.path + "/settings.json");
  File settingsFile = File.fromUri(settingsUri);

  //if settings dont exist create new one
  if (!await settingsFile.exists()) {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory lyghtsDir = Directory.fromUri(Uri.directory(docDir.path + "/Lyghts"));

    AppSettings newSettings = AppSettings(lyghtsDir: lyghtsDir);
    saveSettings(newSettings.toJSON());
    return (newSettings.toJSON());
  }

  String settingsJson = settingsFile.readAsStringSync();
  return jsonDecode(settingsJson);
}

void saveSettings(Map<String, dynamic> settings) async {
  Directory appDir = await getApplicationSupportDirectory();
  Uri settingsUri = Uri.file(appDir.path + "/settings.json");
  File settingsFile = File.fromUri(settingsUri);

  settingsFile.writeAsStringSync(jsonEncode(settings));
}
