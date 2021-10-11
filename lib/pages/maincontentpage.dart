import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/pages.dart';
import 'package:lyghts_desktop/pages/settingspage.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:lyghts_desktop/widgets.dart';
import 'package:screenshot/screenshot.dart';

bool initialized = false;

class MainContentPage extends StatefulWidget {
  final Function() onLogOut;
  const MainContentPage({Key? key, required this.onLogOut}) : super(key: key);

  @override
  _MainContentPageState createState() => _MainContentPageState();
}

class _MainContentPageState extends State<MainContentPage> {
  PageController contentPageController = PageController(initialPage: 1, keepPage: true);

  ScreenshotController screenshotController = ScreenshotController();

  Plan? selectedPlan;

  Map<Layers, bool> layerVisibility = {
    Layers.camera: true,
    Layers.data: true,
    Layers.decoration: true,
    Layers.light: true,
    Layers.power: true,
    Layers.text: true,
    Layers.shape: true,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    contentPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadProjects(),
      builder: (context, AsyncSnapshot<List<Project>> snapshot) {
        if (snapshot.hasData) {
          if (!initialized) {
            localProjects = snapshot.data ?? [];
            initialized = true;
          }
          return Row(
            children: [
              SideNavBar(
                onPageChange: (index) {
                  contentPageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 750),
                    curve: Curves.easeInOutCubic,
                  );
                },
                onLogOut: widget.onLogOut,
                initialSelected: contentPageController.initialPage,
              ),
              Expanded(
                child: PageView(
                  controller: contentPageController,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  restorationId: "content",
                  children: [
                    const AccountPage(),
                    //TODO: Accountpage
                    PlansPage(
                      onPlanSelected: (plan) {
                        selectedPlan = plan;
                        setState(() {});
                      },
                    ),
                    EditPage(
                      layerVisibility: layerVisibility,
                      screenshotController: screenshotController,
                      selectedPlan: selectedPlan,
                      onLayerVisibilityChanged: (layer) {
                        if (layerVisibility[layer] != null) {
                          layerVisibility[layer] = !layerVisibility[layer]!;
                          setState(() {});
                        }
                      },
                    ),
                    ExportPage(
                      selectedPlan: selectedPlan,
                      screenshotController: screenshotController,
                    ),
                    const DatabasePage(),
                    //TODO: Database Page
                    const SettingsPage(),
                    //TODO: Settings Page
                  ],
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Image.asset("assets/images/logo.png"),
          );
        }
      },
    );
  }
}
