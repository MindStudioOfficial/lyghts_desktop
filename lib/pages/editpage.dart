import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:lyghts_desktop/widgets.dart';
import 'package:lyghts_desktop/models.dart';

class EditPage extends StatefulWidget {
  final Plan? selectedPlan;
  final Map<Layers, bool> layerVisibility;
  final Function(Layers layer) onLayerVisibilityChanged;

  const EditPage({
    Key? key,
    this.selectedPlan,
    required this.layerVisibility,
    required this.onLayerVisibilityChanged,
  }) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  EditTools selectedTool = EditTools.select;
  Offset canvasPos = const Offset(350 - 1000, 50 - 1000);
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

  MouseCursor getCurrentCursor() {
    if (moveClicked) return SystemMouseCursors.allScroll;
    if (selectedTool == EditTools.label) return SystemMouseCursors.text;
    return SystemMouseCursors.basic;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (widget.selectedPlan != null) {
        return Stack(
          children: [
            Listener(
              //CANVAS
              //Detect Scrolling to zoom the plan
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  double scrollAmount = event.scrollDelta.dy;

                  if (scrollAmount < 0) editCanvasScale = editCanvasScale * 1.25;
                  if (scrollAmount > 0) editCanvasScale = editCanvasScale * .75;
                  if (editCanvasScale > 2.1) editCanvasScale = 2.1;
                  if (editCanvasScale < 0.05) editCanvasScale = 0.05;
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
                cursor: getCurrentCursor(),
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
                        child: SizedBox(
                          width: widget.selectedPlan!.size.width + 2000,
                          height: widget.selectedPlan!.size.height + 2000,
                          child: Center(
                            child: EditCanvas(
                              rendering: false,
                              onAbortAddElement: () {
                                selectedDatabaseElement = null;

                                deselectDataBaseElement = true;

                                setState(() {});
                              },
                              layerVisibility: widget.layerVisibility,
                              onUpdate: () {
                                planChanges = true;
                                setState(() {});
                              },
                              onSetElementSelected: (element) {
                                setState(() {
                                  selectedSetElement = element;
                                });
                                planChanges = true;
                              },
                              onMoveBlocked: (blocked) {
                                moveBlocked = blocked;
                                setState(() {});
                              },
                              selectedTool: selectedTool,
                              onAddElement: (element) {
                                widget.selectedPlan!.setLayers.insert(
                                  0,
                                  SetElementLayer(
                                    element: element,
                                    selected: true,
                                    visible: true,
                                  ),
                                );
                                selectedSetElement = element;
                                selectedDatabaseElement = null;
                                planChanges = true;
                                setState(() {
                                  deselectDataBaseElement = true;
                                });
                              },
                              selectedDatabaseElement: selectedDatabaseElement,
                              plan: widget.selectedPlan!,
                              moveBlocked: true,
                              zoomFac: editCanvasScale,
                            ),
                          ),
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
            VerticalRuler(
                constraints: constraints,
                canvasPos: canvasPos,
                canvasScale: editCanvasScale,
                canvasSize: widget.selectedPlan!.size),
            HorizontalRuler(
              constraints: constraints,
              canvasPos: canvasPos,
              canvasScale: editCanvasScale,
              canvasSize: widget.selectedPlan!.size,
            ),
            ToolBar(
              alignment: Alignment.topCenter,
              direction: Axis.horizontal,
              onToolChanged: (tool) {
                selectedTool = tool;
                if (tool == EditTools.label) {
                  selectedDatabaseElement = null;
                  selectedSetElement = null;
                  deselectDataBaseElement = true;
                }
                setState(() {});
              },
              initialTool: selectedTool,
            ),
            DatabaseBar(
              deselect: deselectDataBaseElement,
              onElementSelected: selectedTool == EditTools.label
                  ? (_) {}
                  : (element) {
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
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 300,
                child: Column(
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
                          planChanges = true;
                          setState(() {});
                        },
                        selectedPlan: widget.selectedPlan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              //RESET TRANSFORM BUTTON
              bottom: 50,
              left: 350,
              child: CustomTooltip(
                "Reset Plan Transform",
                child: ResetTransformButton(
                  onPressed: () {
                    if (widget.selectedPlan!.size.height / widget.selectedPlan!.size.width <=
                        constraints.maxHeight / constraints.maxWidth) {
                      editCanvasScale = ((constraints.maxWidth - 300) / widget.selectedPlan!.size.width) * .95;
                    } else {
                      editCanvasScale = (constraints.maxHeight / widget.selectedPlan!.size.height) * .95;
                    }

                    canvasPos = Offset(
                      ((constraints.maxWidth - widget.selectedPlan!.size.width) / 2) + 150 - 1000,
                      ((constraints.maxHeight - widget.selectedPlan!.size.height) / 2) - 1000,
                    );

                    setState(() {});
                  },
                ),
              ),
            ),
            Positioned(
              // SAVE BUTTON
              top: 50,
              left: 350,
              child: CustomTooltip(
                "Save Changes",
                child: SavePlanButton(
                  onPressed: () {
                    if (savePlan(widget.selectedPlan!)) {
                      planChanges = false;
                      setState(() {});
                    }
                  },
                  unsaved: planChanges,
                ),
              ),
            )
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
