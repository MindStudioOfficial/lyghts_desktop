import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:lyghts_desktop/widgets.dart';

class PlanPreview extends StatelessWidget {
  final Plan plan;
  final Function() onPlanSelected;
  final Function() onUpdate;
  const PlanPreview({Key? key, required this.plan, required this.onPlanSelected, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onPlanSelected();
        },
        child: Container(
          height: 250,
          width: 400,
          color: plan.localSelected ? planPreviewSelectedBackgroundColor : planPreviewBackgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      plan.name,
                      style: projectViewerHeaderTextStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    CustomTooltip(
                      "Rename Plan",
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return RenameDialog(
                                initialValue: plan.name,
                                onRenameComplete: (value) {
                                  plan.name = value;
                                  updatePlanUpdatedAt(plan);
                                  onUpdate();
                                },
                                title: "Rename Plan",
                                maxLength: 64,
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit_sharp,
                          size: 20,
                          color: selectedIconColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomTooltip(
                      "Delete Plan",
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                backgroundColor: appBackgroundAccentColor,
                                title: Text(
                                  "Are you sure that you want to delete that plan?",
                                  style: defaultTextStyle.copyWith(fontSize: 25),
                                ),
                                actionsAlignment: MainAxisAlignment.spaceEvenly,
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (localProjects.any((project) => project.plans.any((p) => p == plan))) {
                                        Project lp =
                                            localProjects.firstWhere((project) => project.plans.any((p) => p == plan));
                                        lp.plans.remove(plan);
                                        saveProject(lp);
                                      }
                                      onUpdate();

                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Yes",
                                        style: defaultTextStyle.copyWith(fontSize: 30),
                                      ),
                                    ),
                                    style: iconTextButtonStyle,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Cancel",
                                        style: defaultTextStyle.copyWith(fontSize: 30),
                                      ),
                                    ),
                                    style: iconTextButtonStyle,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete_sharp,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        width: plan.size.width / 4,
                        height: plan.size.height / 4,
                        decoration: canvasBackgroundDecoration,
                        child: Stack(
                          children: [
                            if (plan.backgroundImage != null) Image.memory(plan.backgroundImage!),
                            const Center(
                              child: WaterMarc(alignment: Alignment.center),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
