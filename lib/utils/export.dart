import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfw;

enum ExportFormats {
  png,
  pdf,
}

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
  return '${DateTime.now().toDateTimeShortString()}_${name.toLowerCase().replaceAll("  ", " ").replaceAll(" ", "_")}${i.isNotEmpty ? "_" + i : ""}$extension';
}

Future<bool> exportAsPdf(List<int> imageData, String planName, Size imageSize) async {
  final image = pdfw.MemoryImage(Uint8List.fromList(imageData));

  final pdf = pdfw.Document(creator: "Lyghts.io");

  pdf.addPage(
    pdfw.Page(
      orientation: imageSize.aspectRatio > 1 ? pdfw.PageOrientation.landscape : pdfw.PageOrientation.portrait,
      margin: const pdfw.EdgeInsets.all(16),
      build: (pdfw.Context context) {
        return pdfw.Center(
          child: pdfw.FittedBox(
            fit: pdfw.BoxFit.contain,
            child: pdfw.Image(
              image,
            ),
          ),
        );
      },
    ),
  );

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
