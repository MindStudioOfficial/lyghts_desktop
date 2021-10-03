// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';

ButtonStyle sideNavBarButtonStyle(bool selected) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) {
      if (selected) return sideNavBarButtonSelectedColor;
      return Colors.transparent;
    }),
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  );
}

ButtonStyle toolBarButtonStyle(bool selected) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) {
      if (selected) return toolBarButtonSelectedColor;
      return Colors.transparent;
    }),
    shape: MaterialStateProperty.all(
      const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  );
}

ButtonStyle iconTextButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(iconButtonBackgroundColor),
  shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
);
