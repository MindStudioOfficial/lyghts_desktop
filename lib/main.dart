import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:lomp_desktop/pages.dart';
import 'config.dart';
import 'widgets.dart';
import 'models.dart';

void main() {
  Paint.enableDithering = true;
  runApp(const Main());

  doWhenWindowReady(() {
    appWindow.minSize = minSize;
    appWindow.size = initialSize;
    appWindow.alignment = windowAlignment;
    appWindow.show();
  });
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 1, keepPage: true);
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: appBackgroundDecoration,
          child: Column(
            children: [
              TitleBar(
                titleBarText: appTitle,
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    LoginPage(
                      onLoginSuccess: () {
                        pageController?.animateToPage(1,
                            duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic);
                      },
                    ),
                    MainContentPage(
                      onLogOut: () {
                        pageController?.animateToPage(0,
                            duration: const Duration(milliseconds: 700), curve: Curves.easeOutCubic);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
