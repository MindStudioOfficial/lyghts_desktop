import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:uuid/uuid.dart';

class NewProjectDialog extends StatefulWidget {
  final Function() onProjectCreated;
  const NewProjectDialog({
    Key? key,
    required this.onProjectCreated,
  }) : super(key: key);

  @override
  _NewProjectDialogState createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends State<NewProjectDialog> {
  TextEditingController projectNameController = TextEditingController();
  String filename = "";
  bool fileExists = false;

  void createProject(String name, String filename) {
    Project newPr = Project(
      filename: filename,
      name: name,
      createdAt: DateTime.now(),
      lastUpdatedAt: DateTime.now(),
      uuid: const Uuid().v4(),
      plans: [],
    );

    localProjects.add(newPr);
    saveProject(newPr);
    widget.onProjectCreated();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        'Create New Project',
        style: projectViewerHeaderTextStyle,
      ),
      backgroundColor: appBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: projectNameController,
            decoration: defaultTextFieldDecoration.copyWith(hintText: 'Project Name'),
            style: textFieldStyle,
            maxLines: 1,
            autofocus: true,
            onChanged: (value) {
              filename = value.toLowerCase().replaceAll(" ", "_").replaceAll("__", "_");

              Directory projectsDir = globalSettings.projectsDir;
              if (!projectsDir.existsSync()) {
                projectsDir.createSync(recursive: true);
              }
              File testFile = File('${projectsDir.path}/$filename.lypr');
              fileExists = false;
              int i = 1;
              //check if file with that name already exists
              while (testFile.existsSync()) {
                fileExists = true;
                filename = value.toLowerCase().replaceAll(" ", "_").replaceAll("__", "_") + '_$i';
                testFile = File('${projectsDir.path}/$filename.lypr');
              }
              setState(() {});
            },
            onSubmitted: (value) {
              createProject(value, filename);
              Navigator.pop(context);
            },
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                if (newValue.text.length < 48) return newValue;

                return oldValue;
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            filename + ".lypr",
            style: defaultTextStyle.copyWith(
                color: fileExists ? Colors.red : defaultIconColor, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Spacer(),
              TextButton(
                style: iconTextButtonStyle,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cancel",
                    style: defaultTextStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              TextButton(
                style: highlightedIconTextButtonStyle,
                onPressed: () {
                  createProject(projectNameController.text, filename);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Create",
                    style: defaultTextStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
