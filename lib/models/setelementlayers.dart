import 'package:lyghts_desktop/models.dart';

abstract class SetLayer {
  int id;
  bool visible;
  bool selected;
  bool highlighted;
  String name;
  SetLayer({
    this.id = -1,
    this.visible = true,
    this.selected = false,
    this.highlighted = false,
    this.name = "",
  });

  Map<String, dynamic> toJSON();
  factory SetLayer.fromJSON(Map<String, dynamic> json) {
    if (json['type'] == 'element') {
      return SetElementLayer.fromJSON(json);
    } else {
      return SetGroupLayer.fromJSON(json);
    }
  }

  SetLayer copyWith();
}

class SetElementLayer extends SetLayer {
  SetElement element;

  SetElementLayer({
    required this.element,
    int id = -1,
    bool visible = true,
    bool selected = false,
    bool highlighted = false,
    String name = "",
  }) : super(id: id, visible: visible, selected: selected, highlighted: highlighted, name: name);
  @override
  String toString() {
    return {"element": element, "id": id, "name": name}.toString();
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'element',
      'element': element.toJSON(),
      'id': id,
      'visible': visible,
      'selected': selected,
      'name': name,
    };
  }

  factory SetElementLayer.fromJSON(Map<String, dynamic> json) {
    return SetElementLayer(
      element: SetElement.fromJSON(json['element']),
      id: json['id'] ?? -1,
      selected: json['selected'] ?? false,
      visible: json['visible'] ?? true,
      name: json['name'] ?? "",
    );
  }
  @override
  SetElementLayer copyWith({SetElement? element, int? id, bool? visible, bool? selected, String? name}) {
    return SetElementLayer(
      element: element ?? this.element,
      id: id ?? this.id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      selected: selected ?? this.selected,
    );
  }
}

class SetGroupLayer extends SetLayer {
  List<SetLayer> contents;
  bool expanded;
  bool topHighlighted;
  SetGroupLayer({
    this.contents = const [],
    int id = -1,
    bool visible = true,
    bool selected = false,
    this.expanded = true,
    bool highlighted = false,
    this.topHighlighted = false,
    required String name,
  }) : super(
          id: id,
          visible: visible,
          selected: selected,
          highlighted: highlighted,
          name: name,
        );

  @override
  SetGroupLayer copyWith({
    List<SetLayer>? contents,
    String? name,
    int? id,
    bool? visible,
    bool? selected,
    bool? expanded,
  }) {
    return SetGroupLayer(
      name: name ?? this.name,
      contents: contents ?? this.contents,
      expanded: expanded ?? this.expanded,
      id: id ?? this.id,
      selected: selected ?? this.selected,
      visible: visible ?? this.visible,
    );
  }

  void selectAll(bool selected, {int depth = 0}) {
    for (SetLayer layer in contents) {
      layer.selected = selected;
      if (layer is SetGroupLayer) {
        if (depth > 20) return;

        layer.selectAll(selected, depth: depth++);
      } else if (layer is SetElementLayer) {
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
      'name': name,
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
      name: json['name'] ?? "",
    );
  }

  bool removeElement(SetElement e) {
    for (int i = 0; i < contents.length; i++) {
      SetLayer layer = contents[i];
      if (layer is SetGroupLayer) {
        if (layer.removeElement(e)) return true;
      } else if (layer is SetElementLayer) {
        if (layer.element == e) {
          contents.removeAt(i);
          return true;
        }
      }
    }
    return false;
  }

  void setVisibility(bool visible, {int depth = 0}) {
    this.visible = visible;
    for (SetLayer layer in contents) {
      layer.visible = visible;
      if (layer is SetGroupLayer) {
        if (depth < 20) {
          layer.setVisibility(visible, depth: depth++);
        }
      } else if (layer is SetElementLayer) {
        layer.element.visible = visible;
      }
    }
  }
}
