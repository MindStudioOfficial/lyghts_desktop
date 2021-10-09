import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lyghts_desktop/models.dart';

class RenameDialog extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function(String value) onRenameComplete;
  final int maxLength;
  const RenameDialog({
    Key? key,
    required this.initialValue,
    required this.onRenameComplete,
    required this.title,
    required this.maxLength,
  }) : super(key: key);

  @override
  _RenameDialogState createState() => _RenameDialogState();
}

class _RenameDialogState extends State<RenameDialog> {
  TextEditingController renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    renameController.text = widget.initialValue;
    renameController.selection = TextSelection(baseOffset: 0, extentOffset: renameController.text.length);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        widget.title,
        style: projectViewerHeaderTextStyle,
      ),
      backgroundColor: appBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      children: [
        TextField(
          controller: renameController,
          decoration: defaultTextFieldDecoration.copyWith(hintText: widget.initialValue),
          style: textFieldStyle,
          maxLines: 1,
          maxLength: widget.maxLength,
          autofocus: true,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onSubmitted: (value) {
            widget.onRenameComplete(value);
            Navigator.pop(context);
          },
        ),
        Row(
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
                widget.onRenameComplete(renameController.text);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Apply",
                  style: defaultTextStyle.copyWith(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
