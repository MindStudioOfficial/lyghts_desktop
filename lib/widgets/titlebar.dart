import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';
import 'package:lomp_desktop/widgets.dart';

class TitleBar extends StatefulWidget {
  final String titleBarText;
  const TitleBar({Key? key, this.titleBarText = ""}) : super(key: key);

  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBackgroundAccentColor,
      child: WindowTitleBarBox(
        child: Row(
          children: [
            const SizedBox(
              width: 136,
            ),
            Expanded(
              child: MoveWindow(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.titleBarText,
                    style: titleBarStyle,
                  ),
                ),
              ),
            ),
            const WindowButtons()
          ],
        ),
      ),
    );
  }
}
