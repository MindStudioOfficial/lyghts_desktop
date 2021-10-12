import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/utils.dart';

bool initialized = false;

Future<bool> loadApp() async {
  if (initialized) return true;
  Map<String, dynamic> settings = await loadSettings();
  globalSettings = AppSettings.fromJSON(settings);

  localProjects = await loadProjects();

  return true;
}
