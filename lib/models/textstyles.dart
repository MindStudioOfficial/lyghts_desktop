import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lyghts_desktop/models.dart';

TextStyle defaultTextStyle = GoogleFonts.getFont(
  "Montserrat",
  textStyle: const TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w100),
);

TextStyle textFieldStyle = defaultTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.normal);

TextStyle titleBarStyle = defaultTextStyle.copyWith(
    fontSize: 16, fontWeight: FontWeight.normal, color: appWindowTitleColor, letterSpacing: 3);

TextStyle databaseTextStyle = defaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.normal);
TextStyle databaseManufacturerTextStyle = databaseTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18);
TextStyle databaseModelTextStyle = databaseTextStyle.copyWith(fontSize: 18);
TextStyle waterMarcTextStyle = defaultTextStyle.copyWith(
  fontSize: 65,
  fontWeight: FontWeight.bold,
  color: waterMarcTextColor,
);

TextStyle projectViewerHeaderTextStyle = defaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold);
TextStyle projectViewerHeaderPropertyTextStyle = defaultTextStyle.copyWith(
  fontSize: 24,
  fontWeight: FontWeight.normal,
  color: projectViewerHeaderPropertyTextColor,
);

TextStyle propertyHeaderStyle = defaultTextStyle.copyWith(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

TextStyle propertyStyle = defaultTextStyle.copyWith(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w100,
);
