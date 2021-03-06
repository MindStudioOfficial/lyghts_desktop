import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/widgets.dart';
import 'package:lyghts_desktop/utils.dart';

void updatePlanUpdatedAt(Plan p) {
  p.lastUpdatedAt = DateTime.now();
  updateProjectUpdatedAt(localProjects.firstWhere((project) => project.plans.any((plan) => plan == p)));
}

void updateProjectUpdatedAt(Project pr) {
  pr.lastUpdatedAt = DateTime.now();
}

class ProjectViewer extends StatefulWidget {
  final Project project;
  final BoxConstraints constraints;
  final Function() onUpdate;
  final Function(Plan plan) onPlanSelected;

  const ProjectViewer({
    Key? key,
    required this.project,
    required this.onPlanSelected,
    required this.constraints,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<ProjectViewer> createState() => _ProjectViewerState();
}

class _ProjectViewerState extends State<ProjectViewer> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            widget.project.localExpanded = !widget.project.localExpanded;
            setState(() {});
          },
          child: Container(
            color: projectViewerHeaderColor,
            child: SizedBox(
              width: widget.constraints.maxWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        widget.project.localExpanded ? Icons.expand_less_sharp : Icons.expand_more_sharp,
                        color: selectedIconColor,
                        size: 25,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.project.name,
                              style: projectViewerHeaderTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          CustomTooltip(
                            "Rename Project",
                            child: IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return RenameDialog(
                                      initialValue: widget.project.name,
                                      onRenameComplete: (value) {
                                        widget.project.name = value;
                                        updateProjectUpdatedAt(widget.project);
                                        widget.onUpdate();
                                      },
                                      title: "Rename Project",
                                      maxLength: 64,
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.edit_sharp,
                                color: selectedIconColor,
                                size: 25,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.project.createdAt.toDateTimeString(" - "),
                        style: projectViewerHeaderPropertyTextStyle,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        widget.project.lastUpdatedAt.toDateTimeString(" - "),
                        style: projectViewerHeaderPropertyTextStyle,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          CustomTooltip(
                            "New Plan",
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return NewPlanDialog(
                                      onNewPlan: (plan) {
                                        widget.project.plans.add(plan);
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                child: Icon(
                                  Icons.add_sharp,
                                  size: 20,
                                  color: selectedIconColor,
                                ),
                              ),
                              style: iconTextButtonStyle,
                            ),
                          ),
                          const Spacer(),
                          CustomTooltip(
                            "Delete Project",
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                        backgroundColor: appBackgroundAccentColor,
                                        title: Text(
                                          "Are you sure that you want to delete that project?",
                                          style: defaultTextStyle.copyWith(fontSize: 25),
                                        ),
                                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              localProjects.remove(widget.project);
                                              widget.onUpdate();
                                              //TODO: actually remove the file

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
                                    });
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                child: Icon(
                                  Icons.delete_sharp,
                                  size: 20,
                                  color: selectedIconColor,
                                ),
                              ),
                              style: iconTextButtonStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 750),
          curve: Curves.easeInOutCubic,
          height: widget.project.localExpanded ? widget.constraints.maxHeight / 2 : 0,
          child: Container(
            width: widget.constraints.maxWidth,
            color: projectViewerBodyColor,
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              child: Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: plans(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> plans() {
    List<Widget> w = [];

    for (Plan plan in widget.project.plans) {
      w.add(
        PlanPreview(
          onUpdate: () {
            widget.onUpdate();

            setState(() {});
          },
          plan: plan,
          onPlanSelected: () {
            widget.onPlanSelected(plan);
            for (Project project in localProjects) {
              for (Plan plan in project.plans) {
                plan.localSelected = false;
              }
            }

            plan.localSelected = true;
            setState(() {});
          },
        ),
      );
    }

    return w;
  }
}
