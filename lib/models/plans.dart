import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lomp_desktop/models.dart';

class Plan {
  Size size;
  DateTime createdAt;
  DateTime lastUpdatedAt;
  String? thumbnailUrl;
  String name;
  bool localSelected;
  List<SetElement> setElements;
  List<SetLayer> setLayers;
  Uint8List? backgroundImage;
  List<Color> colorHistory;

  Plan({
    required this.setLayers,
    this.colorHistory = const [],
    required this.name,
    required this.size,
    required this.createdAt,
    required this.lastUpdatedAt,
    this.backgroundImage,
    this.thumbnailUrl,
    this.localSelected = false,
    required this.setElements,
  });

  factory Plan.fromJSON(Map<String, dynamic> json) {
    return Plan(
      setLayers: List.generate(json['setLayers'].length, (index) {
        List setLayers = json['setLayers'];
        return SetLayer.fromJSON(setLayers[index]);
      }),
      name: json['name'],
      size: Size(json['size']['width'], json['size']['height']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(json['lastUpdatedAt']),
      setElements: [],
      backgroundImage: json['backgroundImage'] != null ? Uint8List.fromList(json['backgroundImage']) : null,
      thumbnailUrl: json['thumbnailUrl'],
      colorHistory: List.generate(json['colorHistory'].length, (index) {
        List ch = json['colorHistory'];
        return Color(ch[index]);
      }),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'name': name,
      'size': {
        'width': size.width,
        'height': size.height,
      },
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastUpdatedAt': lastUpdatedAt.millisecondsSinceEpoch,
      'setLayers': List.generate(
        setLayers.length,
        (i) {
          return setLayers[i].toJSON();
        },
      ),
      'backgroundImage': backgroundImage != null ? backgroundImage!.toList() : null,
      'thumbnailUrl': thumbnailUrl,
      'colorHistory': List.generate(colorHistory.length, (index) {
        return colorHistory[index].value;
      })
    };
  }
}
