import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
          colors: WindowButtonColors(iconNormal: appWindowButtonIconColor, mouseOver: appWindowButtonOverColor),
        ),
        MaximizeWindowButtonEdit(
          colors: WindowButtonColors(iconNormal: appWindowButtonIconColor, mouseOver: appWindowButtonOverColor),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(iconNormal: appWindowButtonIconColor, mouseOver: appWindowButtonCloseOverColor),
        ),
      ],
    );
  }
}

class MaximizeWindowButtonEdit extends WindowButton {
  MaximizeWindowButtonEdit({Key? key, WindowButtonColors? colors, VoidCallback? onPressed, bool? animate})
      : super(
          key: key,
          colors: colors,
          animate: animate ?? false,
          iconBuilder: (buttonContext) => !appWindow.isMaximized
              ? MaximizeIcon(color: buttonContext.iconColor)
              : RestoreIcon(color: buttonContext.iconColor),
          onPressed: onPressed ?? () => !appWindow.isMaximized ? appWindow.maximize() : appWindow.restore(),
        );
}
