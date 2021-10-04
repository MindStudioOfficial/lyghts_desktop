import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/painters/camerapainter.dart';
import 'package:lyghts_desktop/painters/lightpainter.dart';
import 'package:lyghts_desktop/painters/shapepainter.dart';
import 'package:lyghts_desktop/utils/binary.dart';
import 'package:lyghts_desktop/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vector_math/vector_math.dart' as vm;

class EditCanvas extends StatefulWidget {
  final Plan plan;
  final SetElement? selectedDatabaseElement;
  final EditTools selectedTool;
  final Function(SetElement element) onAddElement;
  final Function(bool blocked) onMoveBlocked;
  final bool moveBlocked;
  final double zoomFac;
  final Function(SetElement? element) onSetElementSelected;
  final Function() onUpdate;
  final Function() onAbortAddElement;
  final ScreenshotController screenshotController;
  final Map<Layers, bool> layerVisibility;

  const EditCanvas({
    Key? key,
    required this.onAbortAddElement,
    required this.plan,
    required this.selectedDatabaseElement,
    required this.onAddElement,
    required this.selectedTool,
    required this.onMoveBlocked,
    required this.moveBlocked,
    required this.zoomFac,
    required this.onSetElementSelected,
    required this.onUpdate,
    required this.screenshotController,
    required this.layerVisibility,
  }) : super(key: key);

  @override
  State<EditCanvas> createState() => _EditCanvasState();
}

class _EditCanvasState extends State<EditCanvas> {
  Size painterSize = const Size(5000, 5000);
  Offset localCurserPos = const Offset(0, 0);
  DateTime previousClick = DateTime.fromMillisecondsSinceEpoch(0);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widgetKey = GlobalKey();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.plan.name,
          style: defaultTextStyle.copyWith(fontSize: 45),
        ),
        Screenshot(
          controller: widget.screenshotController,
          child: Container(
            key: widgetKey,
            decoration: canvasBackgroundDecoration,
            width: widget.plan.size.width,
            height: widget.plan.size.height,
            child: Stack(
              children: [
                if (widget.plan.backgroundImage != null) Image.memory(widget.plan.backgroundImage!),
                const WaterMarc(
                  alignment: Alignment.bottomLeft,
                ),
                ...generateSetElements(widget.plan.setLayers),
                selectedOverlay(),
                if (widget.selectedDatabaseElement != null)
                  Listener(
                    //Hitdetector for new SetElements
                    onPointerDown: (details) {
                      //Place on Leftclick
                      if (checkBit(details.buttons, 0)) {
                        resetSelected();
                        widget.onAddElement(
                          widget.selectedDatabaseElement!.copyWith(position: details.localPosition, selected: true),
                        );
                        //widget.onSetElementSelected(widget.plan.setLayers.);
                        setState(() {});
                      }
                      //Abort on Rightclick or Middleclick
                      if (checkBit(details.buttons, 1) || checkBit(details.buttons, 2)) {
                        widget.onAbortAddElement();
                      }
                    },
                    onPointerHover: (event) {
                      if (widget.selectedDatabaseElement != null) {
                        setState(() {
                          localCurserPos = event.localPosition;
                        });
                      }
                    },
                    child: Container(
                      color: Colors.black.withOpacity(.1),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///Reset selected SetElements
  void resetSelected() {
    widget.onSetElementSelected(null);
    for (SetLayer l in widget.plan.setLayers) {
      if (l is SetElementLayer) {
        l.selected = false;
        l.element.selected = false;
      }
      if (l is SetGroupLayer) {
        l.selectAll(false);
      }
    }
  }

  Widget getElement(SetElement e) {
    MouseCursor cursor = SystemMouseCursors.basic;
    switch (widget.selectedTool) {
      case EditTools.move:
        cursor = SystemMouseCursors.move;
        break;
      case EditTools.select:
        cursor = SystemMouseCursors.click;
        break;

      default:
        cursor = SystemMouseCursors.basic;
    }

    return Positioned(
      left: e.position.dx - painterSize.width / 2,
      top: e.position.dy - painterSize.height / 2,
      child: SizedBox(
        width: painterSize.width,
        height: painterSize.height,
        child: Center(
          child: Stack(
            children: [
              if (e is LightFixture)
                CustomPaint(
                  size: painterSize,
                  painter: LightPainter(
                    angle: e.angle,
                    opening: e.opening ?? 10,
                    range: e.range ?? 300,
                  ),
                ),
              if (e is Camera)
                CustomPaint(
                  size: painterSize,
                  painter: CameraPainter(
                    angle: e.angle,
                    focalLength: e.focalLength ?? 35,
                  ),
                ),
              if (e is SetShape)
                CustomPaint(
                  size: painterSize,
                  painter: ShapePainter(
                    angle: e.angle,
                    shapeSize: e.size,
                    fill: e.fill,
                    outline: e.outline,
                    type: e.type,
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: MouseRegion(
                  cursor: cursor,
                  child: GestureDetector(
                    // just for blocking event to parent detector
                    onPanStart: (details) {},
                    onTap: () {
                      if (!e.selected) {
                        resetSelected();
                        e.selected = true;
                        widget.onSetElementSelected(e);
                      } else {
                        widget.onSetElementSelected(null);
                        e.selected = false;
                      }
                    },
                    child: Listener(
                      onPointerMove: (event) {
                        if (widget.selectedTool == EditTools.move && checkBit(event.buttons, 0)) {
                          widget.onMoveBlocked(true);
                          if (widget.moveBlocked) {
                            Offset newPos = e.position + event.delta / widget.zoomFac;
                            if (newPos.dx > 0 && newPos.dx < widget.plan.size.width) {
                              if (newPos.dy > 0 && newPos.dy < widget.plan.size.height) {
                                e.position = newPos;
                              }
                            }
                          }

                          setState(() {});
                        }
                      },
                      onPointerUp: (event) {
                        widget.onMoveBlocked(false);
                      },
                      child: Container(
                        decoration: e.selected ? selectedElementDecoration : unselectedElementDecoration,
                        width: 100,
                        height: 100,
                        child: Transform.rotate(angle: vm.radians(-e.angle + -90), child: elementIcon(e)),
                      ),
                    ),
                  ),
                ),
              ),
              if (e.selected && widget.selectedTool == EditTools.select)
                Positioned(
                  left: (painterSize.width) / 2 - 12.5 - 50,
                  top: (painterSize.height) / 2 - 12.5 - 50,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.allScroll,
                    child: GestureDetector(
                      onPanStart: (details) {},
                      onTap: () {},
                      child: Listener(
                        onPointerMove: (event) {
                          if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                            setState(() {
                              e.position += event.localDelta;
                            });
                          }
                        },
                        child: moveCircle(),
                      ),
                    ),
                  ),
                ),
              if (e.selected && widget.selectedTool == EditTools.select)
                Positioned(
                  left: (painterSize.width) / 2 - 12.5 - 50,
                  top: (painterSize.height) / 2 - 12.5 + 50,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          for (int i = 0; i < widget.plan.setLayers.length; i++) {
                            SetLayer layer = widget.plan.setLayers[i];
                            if (layer is SetElementLayer && layer.element == e) {
                              widget.plan.setLayers.removeAt(i);
                            } else if (layer is SetGroupLayer) {
                              layer.remove(e);
                            }
                          }
                        });
                      },
                      child: removeCircle(),
                    ),
                  ),
                ),
              if (e.selected && widget.selectedTool == EditTools.select)
                if (e is LightFixture)
                  Positioned(
                    left: (painterSize.width) / 2 - 12.5 + (e.range ?? 300) * cos(vm.radians(-e.angle)),
                    top: (painterSize.height) / 2 - 12.5 + (e.range ?? 300) * sin(vm.radians(-e.angle)),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: GestureDetector(
                        onPanStart: (details) {},
                        onTap: () {},
                        child: Listener(
                          onPointerMove: (event) {
                            if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                              Offset oldP = Offset((e.range ?? 300) * cos(vm.radians(e.angle)),
                                  (e.range ?? 300) * sin(vm.radians(-e.angle)));
                              Offset newP = oldP + event.delta / widget.zoomFac;

                              e.angle = -vm.degrees(newP.direction);
                              e.range = newP.distance;
                              widget.onUpdate();
                              setState(() {});
                            }
                          },
                          child: rotateCircle(),
                        ),
                      ),
                    ),
                  ),
              if (e.selected && widget.selectedTool == EditTools.select)
                if (e is LightFixture)
                  Positioned(
                    left: (painterSize.width) / 2 -
                        12.5 +
                        (e.range ?? 300) * cos(vm.radians(-e.angle - (e.opening ?? 10) / 2)),
                    top: (painterSize.height) / 2 -
                        12.5 +
                        (e.range ?? 300) * sin(vm.radians(-e.angle - (e.opening ?? 10) / 2)),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: GestureDetector(
                        onPanStart: (details) {},
                        onTap: () {},
                        child: Listener(
                          onPointerMove: (event) {
                            if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                              Offset oldP = Offset((e.range ?? 300) * cos(vm.radians(-e.angle - (e.opening ?? 10) / 2)),
                                  (e.range ?? 300) * sin(vm.radians(-e.angle - (e.opening ?? 10) / 2)));
                              Offset newP = oldP + event.delta / widget.zoomFac;
                              final delta = vm.degrees(-newP.direction + oldP.direction);

                              e.opening ??= 5;
                              double newOp = e.opening! + delta;
                              if (newOp < 360 && newOp > 0) e.opening = newOp;
                              widget.onUpdate();
                              setState(() {});
                            }
                          },
                          child: openCircle(),
                        ),
                      ),
                    ),
                  ),
              if (e.selected && widget.selectedTool == EditTools.select)
                if (e is Camera)
                  Positioned(
                    left: (painterSize.width) / 2 - 12.5 + (300) * cos(vm.radians(-e.angle)),
                    top: (painterSize.height) / 2 - 12.5 + (300) * sin(vm.radians(-e.angle)),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: GestureDetector(
                        onPanStart: (details) {},
                        onTap: () {},
                        child: Listener(
                            onPointerMove: (event) {
                              if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                                Offset oldP =
                                    Offset((300) * cos(vm.radians(e.angle)), (300) * sin(vm.radians(-e.angle)));
                                Offset newP = oldP + event.delta / widget.zoomFac;

                                e.angle = -vm.degrees(newP.direction);
                                widget.onUpdate();
                                setState(() {});
                              }
                            },
                            child: rotateCircle()),
                      ),
                    ),
                  ),
              if (e.selected && widget.selectedTool == EditTools.select)
                if (e is Camera)
                  Positioned(
                    left: (painterSize.width) / 2 -
                        12.5 +
                        300 * cos(vm.radians(-e.angle - (vm.degrees(2 * atan(42 / (2 * (e.focalLength ?? 35))))) / 2)),
                    top: (painterSize.height) / 2 -
                        12.5 +
                        300 * sin(vm.radians(-e.angle - (vm.degrees(2 * atan(42 / (2 * (e.focalLength ?? 35))))) / 2)),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: GestureDetector(
                        onPanStart: (details) {},
                        onTap: () {},
                        child: Listener(
                          onPointerMove: (event) {
                            if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                              Offset oldP = Offset(
                                  300 *
                                      cos(vm.radians(
                                          -e.angle - (vm.degrees(2 * atan(42 / (2 * (e.focalLength ?? 35))))) / 2)),
                                  300 *
                                      sin(vm.radians(
                                          -e.angle - (vm.degrees(2 * atan(42 / (2 * (e.focalLength ?? 35))))) / 2)));
                              Offset newP = oldP + event.delta / widget.zoomFac;
                              final delta = vm.degrees(-newP.direction + oldP.direction);
                              double newOp = (vm.degrees(2 * atan(42 / (2 * (e.focalLength ?? 35))))) + delta;
                              double newFocalLength = 35;
                              if (newOp > 2 && newOp < 178) {
                                newFocalLength = 42 / (2 * tan(vm.radians(newOp) / 2));
                                e.focalLength = newFocalLength;
                              }
                              widget.onUpdate();
                              setState(() {});
                            }
                          },
                          child: openCircle(),
                        ),
                      ),
                    ),
                  ),
              if (e.selected && widget.selectedTool == EditTools.select)
                if (e is SetShape)
                  Positioned(
                    left: (painterSize.width) / 2 - 12.5 + (e.size.width / 2) * cos(vm.radians(-e.angle)),
                    top: (painterSize.height) / 2 - 12.5 + (e.size.width / 2) * sin(vm.radians(-e.angle)),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: Listener(
                        onPointerDown: (event) {
                          if (checkBit(event.buttons, 0)) {
                            if (DateTime.now().difference(previousClick).inMilliseconds <= 200) {
                              if (e.angle % 45 == 0) {
                                e.angle += 45;
                              } else {
                                e.angle = 0;
                              }

                              setState(() {});
                            }
                            previousClick = DateTime.now();
                          }
                        },
                        onPointerMove: (event) {
                          if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                            Offset oldP = Offset(
                              100 * cos(vm.radians(-e.angle)),
                              100 * sin(vm.radians(-e.angle)),
                            );

                            Offset newP = oldP + event.delta / widget.zoomFac;
                            final delta = vm.degrees(-newP.direction + oldP.direction);
                            e.angle += (delta * 100).round() / 100;

                            widget.onUpdate();
                            setState(() {});
                          }
                        },
                        child: rotateCircle(),
                      ),
                    ),
                  ),
              if (e.selected && widget.selectedTool == EditTools.select)
                if (e is SetShape)
                  Positioned(
                    left: (painterSize.width) / 2 -
                        12.5 +
                        sqrt(pow(e.size.width / 2, 2) + pow(e.size.height / 2, 2)) *
                            cos(vm.radians(-e.angle) - atan((e.size.height / 2) / (e.size.width / 2))),
                    top: (painterSize.height) / 2 -
                        12.5 +
                        sqrt(pow(e.size.width / 2, 2) + pow(e.size.height / 2, 2)) *
                            sin(vm.radians(-e.angle) - atan((e.size.height / 2) / (e.size.width / 2))),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.precise,
                      child: Listener(
                        onPointerMove: (event) {
                          if (widget.selectedTool == EditTools.select && checkBit(event.buttons, 0)) {
                            Offset oldP = Offset(
                              sqrt(pow(e.size.width / 2, 2) + pow(e.size.height / 2, 2)) *
                                  cos(vm.radians(-e.angle) - atan((e.size.height / 2) / (e.size.width / 2))),
                              sqrt(pow(e.size.width / 2, 2) + pow(e.size.height / 2, 2)) *
                                  sin(vm.radians(-e.angle) - atan((e.size.height / 2) / (e.size.width / 2))),
                            );

                            Offset newP = oldP + (event.delta / widget.zoomFac);
                            double b = -newP.direction - vm.radians(e.angle);

                            Size newSize = Size(2 * newP.distance * cos(b), 2 * newP.distance * sin(b));
                            if (e.type == ShapeType.square || e.type == ShapeType.circle) {
                              newSize = Size(newSize.width, newSize.width);
                            }
                            if (newSize.width > 5 &&
                                newSize.height > 5 &&
                                newSize.width < 4000 &&
                                newSize.height < 4000) e.size = newSize;

                            widget.onUpdate();
                            setState(() {});
                          }
                        },
                        child: scaleCircle(),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkElementVisibility(SetElement e) {
    if ((e is LightFixture && widget.layerVisibility[Layers.light]!) ||
        (e is Camera && widget.layerVisibility[Layers.camera]!) ||
        (e is SetShape && widget.layerVisibility[Layers.shape]!) ||
        (e is SetDecoration && widget.layerVisibility[Layers.decoration]!)) {
      return true;
    } else {
      return false;
    }
  }

  List<Widget> generateSetElements(List<SetLayer> setLayers) {
    List<Widget> w = [];

    for (SetLayer setLayer in setLayers.reversed) {
      if (setLayer is SetElementLayer) {
        if (checkElementVisibility(setLayer.element) && setLayer.visible) {
          w.add(getElement(setLayer.element));
        }
      } else if (setLayer is SetGroupLayer) {
        w.addAll(generateSetElements(setLayer.contents));
      }
    }
    return w;
  }

  Widget elementIcon(SetElement e) {
    if (e is LightFixture) {
      return Icon(
        Icons.tungsten_sharp,
        color: setElementIconColor,
        size: 45,
      );
    }
    if (e is Camera) {
      return Transform.rotate(
        angle: vm.radians(90),
        child: Icon(
          Icons.videocam_sharp,
          color: setElementIconColor,
          size: 45,
        ),
      );
    }
    if (e is SetDecoration) {
      return Container();
    }
    if (e is SetShape) {
      return Container();
    }
    return Icon(
      Icons.help_sharp,
      color: setElementIconColor,
      size: 45,
    );
  }

  Widget selectedOverlay() {
    if (widget.selectedDatabaseElement != null) {
      return Positioned(
        left: localCurserPos.dx - 50,
        top: localCurserPos.dy - 50,
        child: SizedBox(
          width: 100,
          height: 100,
          child: elementIcon(widget.selectedDatabaseElement!),
        ),
      );
    } else {
      return Container();
    }
  }
}

Widget rotateCircle() {
  return SizedBox(
    width: 25,
    height: 25,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle_sharp,
          color: setElementIconAccentColor,
          size: 25,
        ),
        Icon(
          Icons.change_circle_sharp,
          color: setElementIconColor,
          size: 25,
        ),
      ],
    ),
  );
}

Widget moveCircle() {
  return SizedBox(
    width: 25,
    height: 25,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle_sharp,
          color: setElementIconColor,
          size: 25,
        ),
        Icon(
          Icons.open_with_sharp,
          color: setElementIconAccentColor,
          size: 15,
        ),
      ],
    ),
  );
}

Widget openCircle() {
  return SizedBox(
    width: 25,
    height: 25,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle_sharp,
          color: setElementIconColor,
          size: 25,
        ),
        Icon(
          Icons.unfold_more_sharp,
          color: setElementIconAccentColor,
          size: 12.5,
        ),
      ],
    ),
  );
}

Widget scaleCircle() {
  return SizedBox(
    width: 25,
    height: 25,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle_sharp,
          color: setElementIconColor,
          size: 25,
        ),
        Icon(
          Icons.open_in_full_sharp,
          color: setElementIconAccentColor,
          size: 12.5,
        ),
      ],
    ),
  );
}

Widget removeCircle() {
  return SizedBox(
    width: 25,
    height: 25,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.circle_sharp,
          color: setElementIconAccentColor,
          size: 25,
        ),
        Icon(
          Icons.cancel,
          color: setElementRemoveIconColor,
          size: 25,
        ),
      ],
    ),
  );
}
