import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/widgets.dart';

class PlansPage extends StatefulWidget {
  final Function(Plan plan) onPlanSelected;
  final Plan? selectedPlan;
  const PlansPage({
    Key? key,
    required this.onPlanSelected,
    this.selectedPlan,
  }) : super(key: key);

  @override
  _PlansPageState createState() => _PlansPageState();
}

enum sortBy {
  name,
  created,
  lastUpdated,
  size,
}

class _PlansPageState extends State<PlansPage> {
  List<Project> sortedProjects = localProjects;
  bool sortReversed = false;
  sortBy sortby = sortBy.lastUpdated;

  void setSort() {
    sortedProjects = localProjects;
    switch (sortby) {
      case sortBy.name:
        sortedProjects.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case sortBy.created:
        sortedProjects.sort((b, a) => a.createdAt.compareTo(b.createdAt));
        break;
      case sortBy.lastUpdated:
        sortedProjects.sort((b, a) => a.lastUpdatedAt.compareTo(b.lastUpdatedAt));
        break;
      default:
        sortedProjects = localProjects;
    }
    if (sortReversed) sortedProjects = sortedProjects.reversed.toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setSort();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: projectsHeaderColor,
              child: Row(
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.sort_sharp,
                                color: selectedIconColor,
                                size: 25,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: GestureDetector(
                                onTap: () {
                                  if (sortby != sortBy.name) {
                                    sortby = sortBy.name;
                                    sortReversed = false;
                                  } else {
                                    sortReversed = !sortReversed;
                                  }
                                  setSort();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Project Name",
                                          style: projectViewerHeaderTextStyle,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (sortby == sortBy.name)
                                        Icon(
                                          sortReversed ? Icons.north_sharp : Icons.south_sharp,
                                          color: selectedIconColor,
                                          size: 15,
                                        ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const VerticalDivider(
                                        color: Colors.white,
                                        thickness: 1,
                                        width: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if (sortby != sortBy.created) {
                                    sortby = sortBy.created;
                                    sortReversed = false;
                                  } else {
                                    sortReversed = !sortReversed;
                                  }
                                  setSort();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Created",
                                          style: projectViewerHeaderPropertyTextStyle,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (sortby == sortBy.created)
                                        Icon(
                                          sortReversed ? Icons.north_sharp : Icons.south_sharp,
                                          color: selectedIconColor,
                                          size: 15,
                                        ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const VerticalDivider(
                                        color: Colors.white,
                                        thickness: 1,
                                        width: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  if (sortby != sortBy.lastUpdated) {
                                    sortby = sortBy.lastUpdated;
                                    sortReversed = false;
                                  } else {
                                    sortReversed = !sortReversed;
                                  }
                                  setSort();
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Updated",
                                          style: projectViewerHeaderPropertyTextStyle,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (sortby == sortBy.lastUpdated)
                                        Icon(
                                          sortReversed ? Icons.north_sharp : Icons.south_sharp,
                                          color: selectedIconColor,
                                          size: 15,
                                        ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const VerticalDivider(
                                        color: Colors.white,
                                        thickness: 1,
                                        width: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {});
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Icon(
                                        Icons.add_sharp,
                                        size: 25,
                                        color: selectedIconColor,
                                      ),
                                    ),
                                    style: iconTextButtonStyle,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sortedProjects.length,
                itemBuilder: (context, index) {
                  Project project = sortedProjects[index];
                  return ProjectViewer(
                    onUpdate: () {
                      setSort();
                    },
                    project: project,
                    onPlanSelected: (plan) {
                      widget.onPlanSelected(plan);

                      setState(() {});
                    },
                    constraints: constraints,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
