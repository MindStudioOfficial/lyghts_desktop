import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'dart:convert' as conv;

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
  double ratio;

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
    this.ratio = 1, // cm per px
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
      backgroundImage: json['backgroundImage'] != null ? conv.base64.decode(json['backgroundImage']) : null,
      thumbnailUrl: json['thumbnailUrl'],
      colorHistory: List.generate(json['colorHistory'].length, (index) {
        List ch = json['colorHistory'];
        return Color(ch[index]);
      }),
      ratio: json['ratio'] ?? 1,
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
      'backgroundImage': backgroundImage != null ? conv.base64.encode(backgroundImage!.toList()) : null,
      'thumbnailUrl': thumbnailUrl,
      'colorHistory': List.generate(colorHistory.length, (index) {
        return colorHistory[index].value;
      }),
      'ratio': ratio,
    };
  }
}
