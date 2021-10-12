import 'dart:io';
import 'dart:typed_data';

import 'package:lyghts_desktop/utils.dart';
import 'package:pdf/widgets.dart' as pdfw;

Future<bool> exportAsPng(List<int> imageData, String planName) async {
  Directory expDir = globalSettings.exportsDir;
  if (!expDir.existsSync()) {
    try {
      expDir.createSync(recursive: true);
    } catch (e) {
      return false;
    }
  }

  File imageFile = File('${expDir.path}/${generateFilename(planName, ".png")}');
  int i = 1;
  while (imageFile.existsSync()) {
    imageFile = File('${globalSettings.exportsDir.path}/${generateFilename(planName, ".png", i.toString())}');
  }
  try {
    imageFile.writeAsBytesSync(imageData);
  } catch (e) {
    return false;
  }

  return true;
}

String generateFilename(String name, String extension, [String i = ""]) {
  return '${DateTime.now().toDateTimeShortString()}_${name.toLowerCase().replaceAll("  ", " ").replaceAll(" ", "_")}_$i$extension';
}

Future<bool> exportAsPdf(List<int> imageData, String planName) async {
  final image = pdfw.MemoryImage(Uint8List.fromList(imageData));

  final pdf = pdfw.Document();
  pdf.addPage(pdfw.Page(
    build: (pdfw.Context context) {
      return pdfw.FullPage(
        ignoreMargins: false,
        child: pdfw.Center(
          child: pdfw.Image(image),
        ),
      );
    },
  ));

  Directory expDir = globalSettings.exportsDir;
  if (!expDir.existsSync()) {
    try {
      expDir.createSync(recursive: true);
    } catch (e) {
      return false;
    }
  }

  File pdfFile = File('${expDir.path}/${generateFilename(planName, ".pdf")}');
  int i = 1;
  while (pdfFile.existsSync()) {
    pdfFile = File('${globalSettings.exportsDir.path}/${generateFilename(planName, ".pdf", i.toString())}');
  }
  final pdfBytes = await pdf.save();
  try {
    pdfFile.writeAsBytesSync(pdfBytes);
  } catch (e) {
    return false;
  }

  return true;
}
