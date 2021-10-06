import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';

class LayerBar extends StatefulWidget {
  final Function(Layers layer) onLayerVisibilityChanged;
  final Alignment alignment;
  final Axis direction;
  final Map<Layers, bool> layerVisibility;
  const LayerBar({
    Key? key,
    required this.alignment,
    required this.direction,
    required this.onLayerVisibilityChanged,
    required this.layerVisibility,
  }) : super(key: key);

  @override
  _LayerBarState createState() => _LayerBarState();
}

Map<Layers, IconData> layerIcons = {
  Layers.shape: Icons.category_sharp,
  Layers.light: Icons.tungsten_sharp,
  Layers.camera: Icons.videocam_sharp,
  Layers.power: Icons.power_sharp,
  Layers.decoration: Icons.chair_sharp,
  Layers.data: Icons.info_sharp,
  Layers.text: Icons.title,
};

class _LayerBarState extends State<LayerBar> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.alignment,
      child: Container(
        width: 300,
        color: toolBarBackgroundColor,
        child: widget.direction == Axis.horizontal
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: layerButtons(),
                mainAxisSize: MainAxisSize.min,
              )
            : Column(
                children: layerButtons(),
                mainAxisSize: MainAxisSize.min,
              ),
      ),
    );
  }

  List<Widget> layerButtons() {
    List<Widget> w = [];
    layerIcons.forEach((layer, icon) {
      w.add(
        IconButton(
          onPressed: () {
            widget.onLayerVisibilityChanged(layer);
          },
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Icon(
              icon,
              size: 18,
              color: widget.layerVisibility[layer]! ? selectedIconColor : defaultIconColor,
            ),
          ),
        ),
      );
    });
    return w;
  }
}
