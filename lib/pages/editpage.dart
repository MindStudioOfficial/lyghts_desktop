import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lyghts_desktop/utils/binary.dart';
import 'package:lyghts_desktop/widgets.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:screenshot/screenshot.dart';

class EditPage extends StatefulWidget {
  final Plan? selectedPlan;
  final ScreenshotController screenshotController;
  final Map<Layers, bool> layerVisibility;
  final Function(Layers layer) onLayerVisibilityChanged;
  const EditPage({
    Key? key,
    required this.screenshotController,
    this.selectedPlan,
    required this.layerVisibility,
    required this.onLayerVisibilityChanged,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  EditTools selectedTool = EditTools.select;
  Offset canvasPos = const Offset(50, 50);
  double editCanvasScale = 1;
  bool dataBaseBarExpanded = true;
  bool objectInspectorExpanded = true;
  SetElement? selectedDatabaseElement;
  SetElement? selectedSetElement;
  Layers currentLayer = Layers.light;
  bool moveBlocked = false;
  bool moveClicked = false;
  bool deselectDataBaseElement = false;
  bool initialized = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

/*
  void initializePlan() {
    int lastId = 0;

    for (SetElement element in widget.selectedPlan!.setElements) {
      //gives id to id-less SetElements
      if (element.id <= 0) {
        if (lastId < DateTime.now().millisecondsSinceEpoch) {
          element.id = DateTime.now().millisecondsSinceEpoch;
        } else {
          lastId++;
          element.id = lastId;
        }
        lastId = element.id;
      }

      //if setElement is missing from setLayers add it
      if (!widget.selectedPlan!.setLayers.any((setLayer) {
        if (setLayer is SetGroupLayer) {
          return setLayer.contains(element.id);
        } else if (setLayer is SetElementLayer) {
          return setLayer.setElementId == element.id;
        }
        return false;
      })) {
        widget.selectedPlan!.setLayers.add(
          SetElementLayer(setElementId: element.id, id: element.id),
        );
      }
    }
    lastId = 0;

    for (SetLayer layer in widget.selectedPlan!.setLayers) {
      if (layer is SetGroupLayer) {
        if (layer.id <= 0) {
          if (lastId < DateTime.now().millisecondsSinceEpoch) {
            layer.id = DateTime.now().millisecondsSinceEpoch;
          } else {
            lastId++;
            layer.id = lastId;
          }
          lastId = layer.id;
        }
      }
    }

    initialized = true;
  }*/

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.selectedPlan != null) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                LayerBar(
                  layerVisibility: widget.layerVisibility,
                  alignment: Alignment.topLeft,
                  direction: Axis.horizontal,
                  onLayerVisibilityChanged: (layer) {
                    widget.onLayerVisibilityChanged(layer);
                  },
                ),
                Expanded(
                  child: LayerViewer(
                    onSetElementSelected: (element) {
                      setState(() {
                        selectedSetElement = element;
                      });
                    },
                    onUpdate: () {
                      setState(() {});
                    },
                    selectedPlan: widget.selectedPlan,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  Listener(
                    //Detect Scrolling to zoom the plan
                    onPointerSignal: (event) {
                      if (event is PointerScrollEvent) {
                        double scrollAmount = event.scrollDelta.dy;

                        if (scrollAmount < 0) editCanvasScale = editCanvasScale * 1.25;
                        if (scrollAmount > 0) editCanvasScale = editCanvasScale * .75;
                        setState(() {});
                      }
                    },
                    //Detect right or middle click down
                    onPointerDown: (event) {
                      if (checkBit(event.buttons, 1) || checkBit(event.buttons, 2)) {
                        setState(() {
                          moveClicked = true;
                        });
                      }
                    },
                    //Detect right or middle click up
                    onPointerUp: (event) {
                      setState(() {
                        moveClicked = false;
                      });
                    },
                    //Detect right or middle click move for moving the plan
                    onPointerMove: (event) {
                      if (checkBit(event.buttons, 1) || checkBit(event.buttons, 2)) {
                        setState(() {
                          canvasPos += event.localDelta;
                        });
                      }
                    },
                    child: MouseRegion(
                      cursor: moveClicked ? SystemMouseCursors.allScroll : SystemMouseCursors.basic,
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.transparent,
                          ),
                          Positionable(
                            child: AnimatedScale(
                              alignment: Alignment.center,
                              scale: editCanvasScale,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOutCubic,
                              child: EditCanvas(
                                onAbortAddElement: () {
                                  selectedDatabaseElement = null;

                                  deselectDataBaseElement = true;

                                  setState(() {});
                                },
                                layerVisibility: widget.layerVisibility,
                                onUpdate: () {
                                  setState(() {});
                                },
                                onSetElementSelected: (element) {
                                  setState(() {
                                    selectedSetElement = element;
                                  });
                                },
                                onMoveBlocked: (blocked) {
                                  moveBlocked = blocked;
                                  setState(() {});
                                },
                                selectedTool: selectedTool,
                                onAddElement: (element) {
                                  widget.selectedPlan!.setLayers
                                      .insert(0, SetElementLayer(element: element, selected: true, visible: true));
                                  selectedSetElement = element;
                                  selectedDatabaseElement = null;

                                  setState(() {
                                    deselectDataBaseElement = true;
                                  });
                                },
                                screenshotController: widget.screenshotController,
                                selectedDatabaseElement: selectedDatabaseElement,
                                plan: widget.selectedPlan!,
                                moveBlocked: true,
                                zoomFac: editCanvasScale,
                              ),
                            ),
                            position: canvasPos,
                            onPosChanged: (position) {
                              canvasPos = position;
                              setState(() {});
                            },
                            movable: selectedTool == EditTools.move && !moveBlocked,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ToolBar(
                    alignment: Alignment.topCenter,
                    direction: Axis.horizontal,
                    onToolChanged: (tool) {
                      selectedTool = tool;
                      setState(() {});
                    },
                    initialTool: selectedTool,
                  ),
                  DatabaseBar(
                    deselect: deselectDataBaseElement,
                    onElementSelected: (element) {
                      deselectDataBaseElement = false;
                      selectedDatabaseElement = element;
                      setState(() {});
                    },
                    height: constraints.maxHeight * 0.499,
                    alignment: Alignment.topRight,
                    onExpandChange: () {
                      dataBaseBarExpanded = !dataBaseBarExpanded;
                      setState(() {});
                    },
                    expanded: dataBaseBarExpanded,
                    currentLayer: currentLayer,
                    onCurrentLayerChanged: (layer) {
                      currentLayer = layer;
                      setState(() {});
                    },
                  ),
                  ObjectInspector(
                    setElement: selectedSetElement,
                    height: constraints.maxHeight * 0.499,
                    alignment: Alignment.bottomRight,
                    onExpandChange: () {
                      objectInspectorExpanded = !objectInspectorExpanded;
                      setState(() {});
                    },
                    onUpdate: () {
                      setState(() {});
                    },
                    selectedPlan: widget.selectedPlan,
                    expanded: objectInspectorExpanded,
                    onColorHistoryChanged: (colorHistory) {
                      if (widget.selectedPlan != null) widget.selectedPlan!.colorHistory = colorHistory;
                      setState(() {});
                    },
                  ),
                  Positioned(
                    bottom: 50,
                    left: 50,
                    child: ResetTransformButton(
                      onPressed: () {
                        if (widget.selectedPlan!.size.height / widget.selectedPlan!.size.width <=
                            constraints.maxHeight / constraints.maxWidth) {
                          editCanvasScale = (constraints.maxWidth / widget.selectedPlan!.size.width) * .95;
                        } else {
                          editCanvasScale = (constraints.maxHeight / widget.selectedPlan!.size.height) * .95;
                        }

                        canvasPos = Offset(
                          (constraints.maxWidth - widget.selectedPlan!.size.width) / 2,
                          (constraints.maxHeight - widget.selectedPlan!.size.height) / 2,
                        );

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return Center(
          child: Text(
            "No Plan Selected",
            style: waterMarcTextStyle,
          ),
        );
      }
    });
  }
}
