import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
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
                    IconButton(
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
