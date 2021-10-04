// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class SideNavBar extends StatefulWidget {
  final Function(int index) onPageChange;
  final Function() onLogOut;
  final int? initialSelected;
  const SideNavBar({
    Key? key,
    required this.onPageChange,
    required this.onLogOut,
    this.initialSelected,
  }) : super(key: key);

  @override
  _SideNavBarState createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  ScrollController sideBarScrollController = ScrollController();
  Map<String, IconData> pages = {
    "account": Icons.account_circle_sharp,
    "plans": Icons.map_sharp,
    "edit": Icons.edit_sharp,
    "export": Icons.print_sharp,
    "database": Icons.tungsten_sharp,
    "settings": Icons.settings_sharp,
  };
  int selected = 0;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected ?? 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          constraints: constraints,
          color: sideNavBarBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: sideBarScrollController,
                  physics: const ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: pageIcons(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  widget.onLogOut();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Icon(
                    Icons.logout_sharp,
                    size: 35,
                    color: defaultIconColor,
                  ),
                ),
                style: sideNavBarButtonStyle(false),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> pageIcons() {
    List<Widget> w = [];
    pages.forEach((key, value) {
      int i = pages.keys.toList().indexOf(key);

      w.add(
        TextButton(
          onPressed: () {
            widget.onPageChange(i);
            selected = i;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Icon(
              value,
              size: 35,
              color: selected == i ? selectedIconColor : defaultIconColor,
            ),
          ),
          style: sideNavBarButtonStyle(selected == i),
        ),
      );
    });
    return w;
  }
}
