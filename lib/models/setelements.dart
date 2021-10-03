import 'package:flutter/material.dart';

class Camera extends SetElement {
  String? manufacturer;

  String? model;
  double? focalLength;
  bool? zoom;
  CameraMount? cameraMount;
  String? cameraOperator;
  Camera({
    double angle = 0,
    Offset position = const Offset(0, 0),
    String notes = "",
    bool selected = false,
    bool visible = true,
    this.manufacturer,
    this.focalLength,
    this.zoom,
    this.cameraMount,
    this.cameraOperator,
    this.model,
    int id = -1,
  }) : super(angle: angle, position: position, notes: notes, selected: selected, visible: visible, id: id);

  @override
  Camera copyWith({
    double? angle,
    Offset? position,
    String? notes,
    bool? selected,
    bool? visibile,
    String? manufacturer,
    String? model,
    double? focalLength,
    bool? zoom,
    CameraMount? cameraMount,
    String? cameraOperator,
    int? id,
  }) {
    return Camera(
      angle: angle ?? this.angle,
      cameraMount: cameraMount ?? this.cameraMount,
      cameraOperator: cameraOperator ?? this.cameraOperator,
      focalLength: focalLength ?? this.focalLength,
      manufacturer: manufacturer ?? this.manufacturer,
      model: model ?? this.model,
      notes: notes ?? this.notes,
      position: position ?? this.position,
      selected: selected ?? this.selected,
      visible: visible,
      zoom: zoom ?? this.zoom,
      id: id ?? this.id,
    );
  }

  factory Camera.fromJSON(Map<String, dynamic> json) {
    return Camera(
      angle: json['angle'],
      cameraMount: json['cameraMount'] != null ? CameraMount.values[json['cameraMount']] : null,
      model: json['model'],
      focalLength: json['focalLength'],
      cameraOperator: json['cameraOperator'],
      id: json['id'],
      manufacturer: json['manufacturer'],
      notes: json['notes'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      selected: json['selected'],
      visible: json['visible'],
      zoom: json['zoom'],
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'camera',
      'id': id,
      'angle': angle,
      'position': {
        'dx': position.dx,
        'dy': position.dy,
      },
      'notes': notes,
      'selected': selected,
      'visible': visible,
      'manufacturer': manufacturer,
      'model': model,
      'focalLength': focalLength,
      'zoom': zoom,
      'cameraMount': cameraMount != null ? cameraMount!.index : null,
      'cameraOperator': cameraOperator,
    };
  }

  @override
  String getSearchString() {
    return "$manufacturer $model".toLowerCase();
  }

  @override
  String getDisplayString() {
    return "Camera $manufacturer $model";
  }
}

enum CameraMount {
  tripod,
  gimbal,
  crane,
  drone,
  slider,
  handheld,
  jib,
  spidercam,
  steadycam,
}

enum DMXBitDepth {
  bit8,
  bit16,
  both,
}

enum Lenses {
  fresnel,
  planoConvex,
  ledLense,
  none,
}

enum LightColors {
  cw,
  rgbl,
  rgbw,
  r,
  g,
  b,
  ww,
  none,
  k3000,
  k3200,
  k5600,
  k5500,
  uv,
}

class LightFixture extends SetElement {
  String? manufacturer;

  String? model;
  double? power;
  double? maxVoltage;
  double? minVoltage;
  double? frequency;
  double? minOpening;
  double? maxOpening;
  double? opening;
  double? range; // 0-360
  double? weight;
  double? maxPan;
  double? maxTilt;
  double? lightPower;
  bool? fanless;
  bool? zoom;
  bool? movable;
  bool? dimmable;
  LightSources? lightSource;
  Lenses? lens;
  PowerPlugs? powerPlug;
  ProtectionClasses? protectionClass;
  LightColors? lightColor;
  Mounts? mount;
  DMXBitDepth? dmxBitDepth;
  int? dmxAddress;
  int? dmxUniverse;
  int? channelNumber;
  int? powerPatchNumber;
  LightFixture({
    double angle = 0,
    Offset position = const Offset(0, 0),
    String notes = "",
    bool selected = false,
    bool visible = true,
    this.manufacturer,
    this.model,
    this.power,
    this.channelNumber,
    this.dimmable,
    this.dmxAddress,
    this.dmxBitDepth,
    this.dmxUniverse,
    this.fanless,
    this.frequency,
    this.lens,
    this.lightColor,
    this.lightPower,
    this.lightSource,
    this.maxOpening,
    this.maxPan,
    this.maxTilt,
    this.maxVoltage,
    this.minOpening,
    this.minVoltage,
    this.mount,
    this.movable,
    this.opening,
    this.powerPatchNumber,
    this.powerPlug,
    this.protectionClass,
    this.range,
    this.weight,
    this.zoom,
    int id = -1,
  }) : super(position: position, angle: angle, notes: notes, selected: selected, visible: visible, id: id);

  @override
  LightFixture copyWith({
    double? angle,
    Offset? position,
    String? notes,
    bool? selected,
    bool? visibile,
    String? manufacturer,
    String? model,
    double? power,
    double? maxVoltage,
    double? minVoltage,
    double? frequency,
    double? minOpening,
    double? maxOpening,
    double? opening, // 0-360
    double? range,
    double? weight,
    double? maxPan,
    double? maxTilt,
    double? lightPower,
    bool? fanless,
    bool? zoom,
    bool? movable,
    bool? dimmable,
    LightSources? lightSource,
    Lenses? lens,
    PowerPlugs? powerPlug,
    ProtectionClasses? protectionClass,
    LightColors? lightColor,
    Mounts? mount,
    DMXBitDepth? dmxBitDepth,
    int? dmxAddress,
    int? dmxUniverse,
    int? channelNumber,
    int? powerPatchNumber,
    int? id,
  }) {
    return LightFixture(
      id: id ?? this.id,
      angle: angle ?? this.angle,
      channelNumber: channelNumber ?? this.channelNumber,
      dimmable: dimmable ?? this.dimmable,
      dmxAddress: dmxAddress ?? this.dmxAddress,
      dmxBitDepth: dmxBitDepth ?? this.dmxBitDepth,
      dmxUniverse: dmxUniverse ?? this.dmxUniverse,
      fanless: fanless ?? this.fanless,
      frequency: frequency ?? this.frequency,
      lens: lens ?? this.lens,
      lightColor: lightColor ?? this.lightColor,
      lightPower: lightPower ?? this.lightPower,
      lightSource: lightSource ?? this.lightSource,
      manufacturer: manufacturer ?? this.manufacturer,
      maxOpening: maxOpening ?? this.maxOpening,
      maxPan: maxPan ?? this.maxPan,
      maxTilt: maxTilt ?? this.maxTilt,
      maxVoltage: maxVoltage ?? this.maxVoltage,
      minOpening: minOpening ?? this.minOpening,
      minVoltage: minVoltage ?? this.minVoltage,
      model: model ?? this.model,
      mount: mount ?? this.mount,
      movable: movable ?? this.movable,
      notes: notes ?? this.notes,
      opening: opening ?? this.opening,
      position: position ?? this.position,
      power: power ?? this.power,
      powerPatchNumber: powerPatchNumber ?? this.powerPatchNumber,
      powerPlug: powerPlug ?? this.powerPlug,
      protectionClass: protectionClass ?? this.protectionClass,
      range: range ?? this.range,
      selected: selected ?? this.selected,
      visible: visible,
      weight: weight ?? this.weight,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'lightFixture',
      'id': id,
      'angle': angle,
      'position': {
        'dx': position.dx,
        'dy': position.dy,
      },
      'notes': notes,
      'selected': selected,
      'visible': visible,
      'manufacturer': manufacturer,
      'model': model,
      'power': power,
      'channelNumber': channelNumber,
      'dimmable': dimmable,
      'dmxAddress': dmxAddress,
      'dmxBitDepth': dmxBitDepth,
      'dmxUniverse': dmxUniverse,
      'fanless': fanless,
      'frequency': frequency,
      'lens': lens != null ? lens!.index : null,
      'lightColor': lightColor != null ? lightColor!.index : null,
      'lightPower': lightPower,
      'lightSource': lightSource != null ? lightSource!.index : null,
      'maxOpening': maxOpening,
      'maxPan': maxPan,
      'maxTilt': maxTilt,
      'maxVoltage': maxVoltage,
      'minOpening': minOpening,
      'minVoltage': minVoltage,
      'mount': mount != null ? mount!.index : null,
      'movable': movable,
      'opening': opening,
      'powerPatchNumber': powerPatchNumber,
      'powerPlug': powerPlug != null ? powerPlug!.index : null,
      'protectionClass': protectionClass != null ? protectionClass!.index : null,
      'range': range,
      'weight': weight,
      'zoom': zoom,
    };
  }

  factory LightFixture.fromJSON(Map<String, dynamic> json) {
    return LightFixture(
      angle: json['angle'],
      id: json['id'],
      notes: json['notes'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      selected: json['selected'],
      visible: json['visible'],
      channelNumber: json['channelNumber'],
      dimmable: json['dimmable'],
      dmxAddress: json['dmxAddress'],
      dmxBitDepth: json['dmxBitDepth'],
      dmxUniverse: json['dmxUniverse'],
      fanless: json['fanless'],
      frequency: json['frequency'],
      lens: json['lens'] != null ? Lenses.values[json['lens']] : null,
      lightColor: json['lightColor'] != null ? LightColors.values[json['lightColor']] : null,
      lightPower: json['lightPower'],
      lightSource: json['lightSource'] != null ? LightSources.values[json['lightSource']] : null,
      manufacturer: json['manufacturer'],
      maxOpening: json['maxOpening'],
      maxPan: json['maxPan'],
      maxTilt: json['maxTilt'],
      maxVoltage: json['maxVoltage'],
      minOpening: json['minOpening'],
      minVoltage: json['minVoltage'],
      model: json['model'],
      mount: json['mount'] != null ? Mounts.values[json['mount']] : null,
      movable: json['movable'],
      opening: json['opening'],
      power: json['power'],
      powerPatchNumber: json['powerPatchNumber'],
      powerPlug: json['powerPlug'] != null ? PowerPlugs.values[json['powerPlug']] : null,
      protectionClass: json['protectionClass'] != null ? ProtectionClasses.values[json['protectionClass']] : null,
      range: json['range'],
      weight: json['weight'],
      zoom: json['zoom'],
    );
  }

  @override
  String getSearchString() {
    return "$manufacturer $model".toLowerCase();
  }

  @override
  String getDisplayString() {
    return "Light $manufacturer $model";
  }
}
/*class GeneralSetElement extends SetElement {
  GeneralSetElement({
    double angle = 0,
    Offset position = Offset.zero,
    String notes = "",
  }) : super(angle: angle, position: position, notes: notes);
}*/

enum LightSources {
  halogen,
  led,
  bulb,
  none,
}

enum Mounts {
  spigotTV_16mm,
  spigotTV_28mm,
  spigotTV_32mm,
  spigotTV_35mm,
  spigotTV_36mm,
  spigotTV_50mm,
  screw_1_4inch,
  screw_3_8inch,
  screwM6,
  screwM8,
  screwM10,
  screwM12,
}

enum PowerPlugs {
  nema1,
  nema5_15,
  cee7_17,
  cee7_16,
  bs_546,
  cee7_5,
  cee7_4,
  cee7_7,
  bs_1363,
  si_32,
  as_3112,
  sev_1011,
  ds_608842d1,
  cei13_16vii,
  c1, //rasierapparate
  c5, //micky buchse
  c6, //micky stecker
  c7, //kleingeräte buchse
  c8, //kleingeräte stecker
  c13, //kaltgeräte buchse
  c14, //kaltgeräte stecker
  c15, //warmgeräte buchse
  c16, //warmgeräte stecker
  c19, //kaltgeräte fett
  cee_16BlueLNPE6h,
  cee_32Red3LNPE6h,
  cee_63Red3LNPE,
  cee_125Red3LNPE,
  cee_16YellowLNPE4h,
  cee_16Blue3LNPE9h,
  cee_16Red3LPE6h,
  powerConTrue1,
  powerConTrue1Top,
  none,
}

enum ProtectionClasses {
  ip00,
  ip11,
  ip12,
  ip13,
  ip14,
  ip15,
  ip16,
  ip17,
  ip18,
  ip19,
  ip20,
  ip21,
  ip22,
  ip23,
  ip24,
  ip25,
  ip26,
  ip27,
  ip28,
  ip29,
  ip31,
  ip32,
  ip33,
  ip34,
  ip35,
  ip36,
  ip37,
  ip38,
  ip39,
  ip40,
  ip41,
  ip42,
  ip43,
  ip44,
  ip45,
  ip46,
  ip47,
  ip48,
  ip49,
  ip50,
  ip51,
  ip52,
  ip53,
  ip54,
  ip55,
  ip56,
  ip57,
  ip58,
  ip59,
  ip60,
  ip61,
  ip62,
  ip63,
  ip64,
  ip65,
  ip66,
  ip67,
  ip68,
  ip69,
  none,
}

class SetDecoration extends SetElement {
  SetDecoration({
    double angle = 0,
    Offset position = const Offset(0, 0),
    String notes = "",
    bool selected = false,
    bool visible = true,
    int id = -1,
  }) : super(
          angle: angle,
          position: position,
          notes: notes,
          selected: selected,
          visible: visible,
          id: id,
        );

  @override
  SetDecoration copyWith({
    double? angle,
    Offset? position,
    String? notes,
    bool? selected,
    bool? visibile,
    int? id,
  }) {
    return SetDecoration(
      angle: angle ?? this.angle,
      notes: notes ?? this.notes,
      position: position ?? this.position,
      selected: selected ?? this.selected,
      visible: visible,
      id: id ?? this.id,
    );
  }

  @override
  String getSearchString() {
    return "".toLowerCase();
  }

  @override
  String getDisplayString() {
    return "Decoration $id";
  }

  factory SetDecoration.fromJSON(Map<String, dynamic> json) {
    return SetDecoration(
      angle: json['angle'],
      id: json['id'],
      notes: json['notes'],
      position: Offset(json['position']['dx'], json['position']['dy']),
      selected: json['selected'],
      visible: json['visible'],
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'setDecoration',
      'id': id,
      'angle': angle,
      'position': {
        'dx': position.dx,
        'dy': position.dy,
      },
      'notes': notes,
      'selected': selected,
      'visible': visible,
    };
  }
}

abstract class SetElement {
  double angle;
  int id;
  Offset position;
  String notes;
  bool selected;
  bool visible;
  SetElement({
    this.angle = 0,
    this.position = Offset.zero,
    this.notes = "",
    this.selected = false,
    this.visible = true,
    this.id = -1,
  });

  SetElement copyWith({double angle, Offset position, String notes, bool selected, bool visibile, int id});

  String getSearchString();
  String getDisplayString();

  Map<String, dynamic> toJSON();

  factory SetElement.fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'camera':
        return Camera.fromJSON(json);
      case 'lightFixture':
        return LightFixture.fromJSON(json);
      case 'setShape':
        return SetShape.fromJSON(json);
      case 'setDecoration':
        return SetDecoration.fromJSON(json);
      default:
        return SetShape(
          size: const Size(100, 100),
          type: ShapeType.rectangle,
          fill: Colors.red,
          outline: Colors.black,
          position: const Offset(100, 100),
        );
    }
  }
}

class SetShape extends SetElement {
  Size size;
  ShapeType type;
  Color fill;
  Color outline;
  SetShape({
    int id = -1,
    double angle = 0,
    Offset position = const Offset(0, 0),
    String notes = "",
    bool selected = false,
    bool visible = true,
    required this.size,
    required this.type,
    this.fill = Colors.transparent,
    this.outline = Colors.black,
  }) : super(angle: angle, position: position, notes: notes, selected: selected, visible: visible, id: id);

  @override
  SetShape copyWith({
    double? angle,
    Offset? position,
    String? notes,
    bool? selected,
    bool? visibile,
    Size? size,
    ShapeType? type,
    Color? fill,
    Color? outline,
    int? id,
  }) {
    return SetShape(
      id: id ?? this.id,
      size: size ?? this.size,
      type: type ?? this.type,
      angle: angle ?? this.angle,
      position: position ?? this.position,
      outline: outline ?? this.outline,
      fill: fill ?? this.fill,
      notes: notes ?? this.notes,
      selected: selected ?? this.selected,
      visible: visible,
    );
  }

  factory SetShape.fromJSON(Map<String, dynamic> json) {
    return SetShape(
      angle: json['angle'],
      type: ShapeType.values[json['shapeType']],
      id: json['id'],
      size: Size(json['size']['width'], json['size']['height']),
      fill: Color(json['fill']),
      notes: json['notes'],
      outline: Color(json['outline']),
      position: Offset(json['position']['dx'], json['position']['dy']),
      selected: json['selected'],
      visible: json['visible'],
    );
  }

  @override
  Map<String, dynamic> toJSON() {
    return {
      'type': 'setShape',
      'id': id,
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'shapeType': type.index,
      'fill': fill.value,
      'outline': outline.value,
      'angle': angle,
      'position': {
        'dx': position.dx,
        'dy': position.dy,
      },
      'notes': notes,
      'selected': selected,
      'visible': visible,
    };
  }

  @override
  String getSearchString() {
    return type.toString().split(".").last.toLowerCase();
  }

  @override
  String getDisplayString() {
    return "Shape ${type.toString().split(".").last} $id";
  }
}

enum ShapeType {
  rectangle,
  circle,
  square,
}
