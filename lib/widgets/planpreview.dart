import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/widgets.dart';

class PlanPreview extends StatelessWidget {
  final Plan plan;
  final Function() onPlanSelected;
  const PlanPreview({Key? key, required this.plan, required this.onPlanSelected}) : super(key: key);

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
                child: Text(
                  plan.name,
                  style: projectViewerHeaderTextStyle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
