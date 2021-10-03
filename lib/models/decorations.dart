import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';

BoxDecoration appBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [appBackgroundAccentColor, appBackgroundColor],
    stops: const [0, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
);

BoxDecoration canvasBackgroundDecoration = BoxDecoration(
  gradient: RadialGradient(
    colors: [Colors.white, Colors.grey.shade400],
    tileMode: TileMode.clamp,
    radius: 1,
    center: Alignment.center,
  ),
);

// TEXTFIELD

InputDecoration defaultTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: defaultTextFieldBorderColor,
      width: 1,
      style: BorderStyle.solid,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: defaultTextFieldBorderColor,
      width: 1,
      style: BorderStyle.solid,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: defaultTextFieldFocusedBorderColor,
      width: 1,
      style: BorderStyle.solid,
    ),
  ),
  hintStyle: textFieldStyle.copyWith(color: defaultTextFieldHintColor),
);

BoxDecoration selectedElementDecoration = BoxDecoration(
  border: Border.all(color: setElementSelectedBorderColor, width: 1),
);

BoxDecoration unselectedElementDecoration = BoxDecoration(
  border: Border.all(color: setElementUnselectedBorderColor, width: 1),
);

BoxDecoration colorSelectorDecoration = BoxDecoration(
  border: Border.all(color: colorSelectorOutlineColor, width: 1),
);
