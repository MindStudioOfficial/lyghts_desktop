import 'package:lomp_desktop/models.dart';

abstract class SetLayer {
  int id;
  bool visible;
  bool selected;
  SetLayer({
    this.id = -1,
    this.visible = true,
    this.selected = false,
  });

  Map<String, dynamic> toJSON();
  factory SetLayer.fromJSON(Map<String, dynamic> json) {
    if (json['type'] == 'element') {
      return SetElementLayer.fromJSON(json);
    } else {
      return SetGroupLayer.fromJSON(json);
    }
  }
}

class SetElementLayer extends SetLayer {
  SetElement element;

  SetElementLayer({
    required this.element,
    int id = -1,
    bool visible = true,
    bool selected = false,
  }) : super(
          id: id,
          visible: visible,
          selected: selected = false,
        );
  @override
  String toString() {
    return {"element": element, "id": id}.toString();
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'element',
      'element': element.toJSON(),
      'id': id,
      'visible': visible,
      'selected': selected,
    };
  }

  factory SetElementLayer.fromJSON(Map<String, dynamic> json) {
    return SetElementLayer(
      element: SetElement.fromJSON(json['element']),
      id: json['id'] ?? -1,
      selected: json['selected'] ?? false,
      visible: json['visible'] ?? true,
    );
  }
}

class SetGroupLayer extends SetLayer {
  List<SetLayer> contents;
  bool expanded;
  SetGroupLayer({
    this.contents = const [],
    int id = -1,
    bool visible = true,
    bool selected = false,
    this.expanded = true,
  }) : super(
          id: id,
          visible: visible,
          selected: selected,
        );

  void selectAll(bool selected) {
    for (SetLayer layer in contents) {
      if (layer is SetGroupLayer) {
        layer.selectAll(selected);
      } else if (layer is SetElementLayer) {
        layer.selected = selected;
        layer.element.selected = selected;
      }
    }
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'group',
      'contents': List.generate(contents.length, (index) {
        return contents[index].toJSON();
      }),
      'id': id,
      'visible': visible,
      'selected': selected,
      'expanded': expanded,
    };
  }

  factory SetGroupLayer.fromJSON(Map<String, dynamic> json) {
    List newContents = json['contents'];
    return SetGroupLayer(
      contents: List.generate(newContents.length, (index) {
        return SetLayer.fromJSON(newContents[index]);
      }),
      expanded: json['expanded'] ?? true,
      id: json['id'] ?? -1,
      selected: json['selected'] ?? false,
      visible: json['visible'] ?? true,
    );
  }

  bool remove(SetElement e) {
    for (int i = 0; i < contents.length; i++) {
      SetLayer layer = contents[i];
      if (layer is SetGroupLayer) {
        if (layer.remove(e)) return true;
      } else if (layer is SetElementLayer) {
        if (layer.element == e) {
          contents.removeAt(i);
          return true;
        }
      }
    }
    return false;
  }

  void setVisibility(bool visible) {
    for (SetLayer layer in contents) {
      if (layer is SetGroupLayer) {
        layer.setVisibility(visible);
      } else if (layer is SetElementLayer) {
        layer.visible = visible;
        layer.element.visible = visible;
      }
    }
  }

  /*bool contains(int setElementId) {
    for (SetLayer layer in contents) {
      if (layer is SetGroupLayer) {
        if (layer.contains(setElementId)) return true;
      } else if (layer is SetElementLayer) {
        if (layer.element == setElementId) {
          return true;
        }
      }
    }
    return false;
  }*/

  /*
  bool isVisible(int setElementId) {
    bool visible = false;
    for (SetLayer layer in contents) {
      if (layer is SetGroupLayer) {
        if (layer.contains(setElementId) && layer.isVisible(setElementId) && layer.visible) {
          visible = true;
        }
      } else if (layer is SetElementLayer) {
        return layer.visible;
      }
    }
    return visible;
  }
  */
  /*
  int getIndex(int setElementID) {
    int index = 0;
    for (SetLayer layer in contents) {
      if (layer is SetGroupLayer) {
        index += layer.getIndex(setElementID);
      } else if (layer is SetElementLayer) {
        if (layer.id == setElementID) {
          return index;
        } else {
          index++;
        }
      }
    }

    return index;
  }*/
}
