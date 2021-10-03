import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';

class ToolBar extends StatefulWidget {
  final Function(EditTools tool) onToolChanged;
  final Alignment alignment;
  final Axis direction;
  final EditTools initialTool;
  const ToolBar({
    Key? key,
    required this.onToolChanged,
    required this.alignment,
    required this.direction,
    this.initialTool = EditTools.select,
  }) : super(key: key);

  @override
  _ToolBarState createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Map<EditTools, IconData> toolIcons = {
    EditTools.select: Icons.near_me_sharp,
    EditTools.move: Icons.open_with_sharp,
    EditTools.label: Icons.title_sharp,
  };
  int selectedTool = 0;

  @override
  void initState() {
    super.initState();
    selectedTool = toolIcons.keys.toList().indexOf(widget.initialTool);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Container(
        color: toolBarBackgroundColor,
        child: widget.direction == Axis.horizontal
            ? Row(
                children: toolButtons(),
                mainAxisSize: MainAxisSize.min,
              )
            : Column(
                children: toolButtons(),
                mainAxisSize: MainAxisSize.min,
              ),
      ),
    );
  }

  List<Widget> toolButtons() {
    List<Widget> w = [];
    toolIcons.forEach((tool, icon) {
      int i = toolIcons.keys.toList().indexOf(tool);
      w.add(
        TextButton(
          onPressed: () {
            widget.onToolChanged(tool);
            selectedTool = i;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Icon(
              icon,
              size: 25,
              color: selectedTool == i ? selectedIconColor : defaultIconColor,
            ),
          ),
          style: toolBarButtonStyle(selectedTool == i),
        ),
      );
    });
    return w;
  }
}
