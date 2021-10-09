import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/widgets.dart';

class LayerViewer extends StatefulWidget {
  final Plan? selectedPlan;
  final Function() onUpdate;
  final Function(SetElement? element) onSetElementSelected;
  const LayerViewer({
    Key? key,
    this.selectedPlan,
    required this.onUpdate,
    required this.onSetElementSelected,
  }) : super(key: key);

  @override
  _LayerViewerState createState() => _LayerViewerState();
}

class _LayerViewerState extends State<LayerViewer> {
  bool bottomHighlighted = false;

  SetLayer? selectedLayer;

  @override
  void initState() {
    super.initState();
  }

  SetLayer? getSelected(List<SetLayer> layers, {int depth = 0}) {
    for (SetLayer l in layers) {
      if (l is SetGroupLayer) {
        if (l.selected) {
          return l;
        } else {
          if (depth > 20) return null;
          SetLayer? res = getSelected(l.contents, depth: depth++);
          if (res != null) return res;
        }
      } else if (l is SetElementLayer) {
        if (l.element.selected) {
          return l;
        }
      }
    }
    return null;
  }

  void resetSelected() {
    widget.onSetElementSelected(null);
    for (SetLayer l in widget.selectedPlan!.setLayers) {
      if (l is SetElementLayer) {
        l.selected = false;
        l.element.selected = false;
      }
      if (l is SetGroupLayer) {
        l.selected = false;
        l.selectAll(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedPlan != null) {
      SetLayer? s = getSelected(widget.selectedPlan!.setLayers);
      if (s != null && s != selectedLayer) {
        selectedLayer = s;
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: layerViewerBackgroundColor,
            width: 300,
            height: constraints.maxHeight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: getLayerChildren(widget.selectedPlan!.setLayers, 0),
                    ),
                  ),
                ),
                layerActions(),
              ],
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          "No Plan Selected",
          style: defaultTextStyle,
        ),
      );
    }
  }

  bool removeFromLayers(List<SetLayer> layers, SetLayer layer) {
    for (int i = 0; i < layers.length; i++) {
      SetLayer setLayer = layers[i];
      if (setLayer == layer) {
        if (layers.removeAt(i) == layer) return true;
      } else {
        if (setLayer is SetGroupLayer) {
          if (removeFromLayers(setLayer.contents, layer)) return true;
        }
      }
    }
    return false;
  }

  List<Widget> getLayerChildren(List<SetLayer> layers, int depth) {
    List<Widget> w = [];

    for (int i = 0; i < layers.length; i++) {
      SetLayer l = layers[i];
      w.addAll(
        [
          if (l is SetGroupLayer)
            DragTarget(
              onWillAccept: (data) => data != null && data is SetLayer && data != l,
              onAccept: (data) {
                if (data != null && data is SetLayer) {
                  SetLayer receivedLayer = data;
                  setState(() {
                    l.topHighlighted = false;
                    removeFromLayers(widget.selectedPlan!.setLayers, receivedLayer);
                    layers.insert(i, receivedLayer);
                  });
                  widget.onUpdate();
                }
              },
              onMove: (details) {
                if (!l.topHighlighted && details.data != null && details.data is SetLayer) {
                  setState(() {
                    l.topHighlighted = true;
                  });
                }
              },
              onLeave: (data) {
                if (l.topHighlighted && data != null && data is SetLayer) {
                  setState(() {
                    l.topHighlighted = false;
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 300,
                      height: 8,
                      color: Colors.transparent,
                    ),
                    if (l.topHighlighted)
                      Container(
                        width: 300,
                        height: 4,
                        color: Colors.white,
                      ),
                  ],
                );
              },
            ),
          DragTarget(
            onWillAccept: (data) => data != null && data is SetLayer && data != l,
            onAccept: (data) {
              if (data != null && data is SetLayer) {
                SetLayer receivedLayer = data;
                setState(() {
                  l.highlighted = false;
                  removeFromLayers(widget.selectedPlan!.setLayers, receivedLayer);
                  if (l is SetGroupLayer) {
                    l.contents.insert(0, receivedLayer);
                  } else {
                    layers.insert(i, receivedLayer);
                  }
                });
                widget.onUpdate();
              }
            },
            onMove: (details) {
              if (!l.highlighted && details.data != null && details.data is SetLayer) {
                setState(() {
                  l.highlighted = true;
                });
              }
            },
            onLeave: (data) {
              if (l.highlighted && data != null && data is SetLayer) {
                setState(() {
                  l.highlighted = false;
                });
              }
            },
            builder: (context, candidateData, rejectedData) {
              if (l is SetElementLayer) {
                return Draggable(
                  dragAnchorStrategy: childDragAnchorStrategy,
                  data: l,
                  child: elementLayerWidget(l, depth, l.highlighted, false),
                  feedback: elementLayerWidget(l, depth, l.highlighted, true),
                  childWhenDragging: const SizedBox(height: 8),
                );
              } else if (l is SetGroupLayer) {
                return Draggable(
                  dragAnchorStrategy: childDragAnchorStrategy,
                  data: l,
                  child: groupLayerWidget(l, depth, l.highlighted, l.expanded),
                  feedback: groupLayerFeedback(l),
                  childWhenDragging: const SizedBox(height: 8),
                );
              }
              return Container();
            },
          ),
        ],
      );
    }
    if (depth == 0) {
      w.add(
        DragTarget(
          onWillAccept: (data) => data != null && data is SetLayer,
          onAccept: (data) {
            if (data != null && data is SetLayer) {
              SetLayer receivedLayer = data;
              setState(() {
                bottomHighlighted = false;
                removeFromLayers(widget.selectedPlan!.setLayers, receivedLayer);
                layers.add(receivedLayer);
              });
              widget.onUpdate();
            }
          },
          onMove: (details) {
            if (!bottomHighlighted && details.data != null && details.data is SetLayer) {
              setState(() {
                bottomHighlighted = true;
              });
            }
          },
          onLeave: (data) {
            if (bottomHighlighted && data != null && data is SetLayer) {
              setState(() {
                bottomHighlighted = false;
              });
            }
          },
          builder: (context, candidateData, rejectedData) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (bottomHighlighted)
                  Container(
                    width: 300,
                    height: 4,
                    color: Colors.white,
                  ),
                Container(
                  width: 300,
                  height: 100,
                  color: Colors.transparent,
                ),
              ],
            );
          },
        ),
      );
    }
    return w;
  }

  Widget groupLayerFeedback(SetGroupLayer l) {
    return SizedBox(
      width: 300,
      child: Card(
        color: layerViewerDeselectedColor.withOpacity(.2),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            l.name.isNotEmpty ? l.name : "Group",
            style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget groupLayerWidget(SetGroupLayer l, int depth, bool highlighted, bool expanded) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: depth * 12,
              ),
              SizedBox(
                width: 300 - (depth * 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      color: l.selected ? layerViewerSelectedColor : layerViewerDeselectedColor,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                l.setVisibility(!l.visible);
                              });
                              widget.onUpdate();
                            },
                            icon: Icon(
                              l.visible ? Icons.visibility_sharp : Icons.visibility_off_sharp,
                              color: l.visible ? Colors.white : Colors.grey.shade600,
                              size: 18,
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!l.selected) {
                                    resetSelected();
                                    l.selected = true;
                                    selectedLayer = l;
                                  } else {
                                    l.selected = false;
                                    selectedLayer = null;
                                  }
                                });
                                widget.onUpdate();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  l.name.isNotEmpty ? l.name : "Group",
                                  style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                l.expanded = !l.expanded;
                              });
                            },
                            icon: Icon(
                              expanded ? Icons.expand_less_sharp : Icons.expand_more_sharp,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (highlighted)
                      const SizedBox(
                        width: 300,
                        height: 16,
                        child: Center(
                          child: Icon(
                            Icons.expand_more_sharp,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (expanded)
          Column(
            children: getLayerChildren(l.contents, depth + 1),
          ),
      ],
    );
  }

  Widget getSetElementIcon(SetElement e) {
    if (e is SetShape) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: e.outline.withAlpha(255)),
          borderRadius: e.type == ShapeType.circle ? BorderRadius.circular(10) : BorderRadius.zero,
        ),
        child: ClipRRect(
          borderRadius: e.type == ShapeType.circle ? BorderRadius.circular(10) : BorderRadius.zero,
          child: Container(
            color: e.fill,
          ),
        ),
      );
    }
    if (e is LightFixture) return Icon(Icons.tungsten_sharp, size: 15, color: selectedIconColor);
    if (e is Camera) return Icon(Icons.videocam_sharp, size: 15, color: selectedIconColor);
    if (e is SetDecoration) return Icon(Icons.chair_sharp, size: 15, color: selectedIconColor);
    if (e is SetLabel) return Icon(Icons.title_sharp, size: 15, color: selectedIconColor);
    return Icon(Icons.quiz_sharp, size: 15, color: selectedIconColor);
  }

  Widget elementLayerWidget(SetElementLayer l, int depth, bool highlighted, bool dragged) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (highlighted)
            Container(
              width: 300,
              height: 4,
              color: Colors.white,
            ),
          Row(
            children: [
              SizedBox(
                width: depth * 12,
              ),
              SizedBox(
                width: 300 - (depth * 12),
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  color: dragged
                      ? layerViewerDeselectedColor.withOpacity(.2)
                      : (l.element.selected ? layerViewerSelectedColor : layerViewerDeselectedColor),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      if (!dragged)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              l.visible = !l.visible;
                            });
                            widget.onUpdate();
                          },
                          icon: Icon(
                            l.visible ? Icons.visibility_sharp : Icons.visibility_off_sharp,
                            color: l.visible ? Colors.white : Colors.grey.shade600,
                            size: 18,
                          ),
                        ),
                      if (dragged)
                        const SizedBox(
                          width: 8,
                        ),
                      getSetElementIcon(l.element),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (!dragged) {
                              setState(() {
                                if (!l.element.selected) {
                                  resetSelected();
                                  l.element.selected = true;
                                  widget.onSetElementSelected(l.element);
                                  selectedLayer = l;
                                } else {
                                  widget.onSetElementSelected(null);
                                  l.element.selected = false;
                                  selectedLayer = null;
                                }
                              });
                              widget.onUpdate();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
                            child: Text(
                              l.name.isEmpty ? l.element.getDisplayString() : l.name,
                              style: defaultTextStyle.copyWith(color: Colors.white, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addNewGroup(List<SetLayer> layers) {
    int i = 0;
    SetGroupLayer newLayer = SetGroupLayer(
      contents: [],
      expanded: true,
      highlighted: false,
      selected: true,
      visible: true,
      name: "New Group",
    );
    while (layers.any((element) => ((element is SetGroupLayer) && element.name == newLayer.name)) && i < 128) {
      i++;
      newLayer.name = "New Group $i";
    }
    layers.insert(0, newLayer);
    selectedLayer = newLayer;
  }

  Widget layerActions() {
    return Container(
      width: 300,
      color: toolBarBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              SetLayer? sLayer = selectedLayer;
              resetSelected();
              sLayer != null && sLayer is SetGroupLayer
                  ? {addNewGroup(sLayer.contents)}
                  : {addNewGroup(widget.selectedPlan!.setLayers)};
              setState(() {});
            },
            icon: Icon(
              Icons.library_add_sharp,
              color: selectedIconColor,
              size: 18,
            ),
          ),
          IconButton(
            onPressed: (selectedLayer != null && selectedLayer is SetElementLayer)
                ? () {
                    SetLayer l = selectedLayer!;
                    if (l is SetElementLayer) {
                      SetElement e = l.element;
                      setState(() {
                        resetSelected();
                        widget.selectedPlan!.setLayers.add(
                          l.copyWith(
                            element: e.copyWith(
                              position: e.position + const Offset(100, 100),
                              selected: true,
                            ),
                            name: (l.name.isEmpty ? l.element.getDisplayString() : l.name) + " Copy",
                            selected: true,
                          ),
                        );
                        widget.onSetElementSelected(e);
                        selectedLayer = l;
                      });
                    }
                  }
                : null,
            icon: Icon(
              Icons.content_copy_sharp,
              color: (selectedLayer != null && selectedLayer is SetElementLayer) ? selectedIconColor : defaultIconColor,
            ),
          ),
          IconButton(
            onPressed: selectedLayer != null
                ? () {
                    String initialString = "";
                    if (selectedLayer!.name.isEmpty) {
                      initialString = selectedLayer is SetGroupLayer ? "Unnamed Group" : "Unnamed Element";
                    } else {
                      initialString = selectedLayer!.name;
                    }
                    SetLayer l = selectedLayer!;
                    if (l is SetElementLayer) {
                      SetElement e = l.element;
                      if (e is SetLabel) {
                        initialString = e.text;
                      }
                    }
                    showDialog(
                      context: context,
                      builder: (context) {
                        return RenameDialog(
                          maxLength: 40,
                          title: "Rename Layer",
                          initialValue: initialString,
                          onRenameComplete: (value) {
                            setState(() {
                              if (l is SetElementLayer) {
                                SetElement e = l.element;
                                if (e is SetLabel) {
                                  e.text = value;
                                } else {
                                  selectedLayer!.name = value;
                                }
                              } else {
                                selectedLayer!.name = value;
                              }
                            });
                            widget.onUpdate();
                          },
                        );
                      },
                    );
                  }
                : null,
            icon: Icon(Icons.edit_sharp, color: selectedLayer != null ? selectedIconColor : defaultIconColor),
          ),
          IconButton(
            onPressed: selectedLayer != null
                ? () {
                    setState(() {
                      removeFromLayers(widget.selectedPlan!.setLayers, selectedLayer!);
                      selectedLayer = null;
                    });
                    widget.onUpdate();
                  }
                : null,
            icon: Icon(
              Icons.delete_sharp,
              color: selectedLayer != null ? Colors.red : defaultIconColor,
            ),
          ),
        ],
      ),
    );
  }
}
