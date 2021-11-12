import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lyghts_desktop/models.dart';
import 'package:lyghts_desktop/utils.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:lyghts_desktop/widgets.dart';

class CustomColorPicker extends StatelessWidget {
  final Size size;
  final Color initialColor;
  final Function(Color color) onColorChanged;
  final List<Color> colorHistory;
  final Function(List<Color> colorHistory) onColorHistoryChanged;
  const CustomColorPicker({
    Key? key,
    required this.onColorHistoryChanged,
    required this.colorHistory,
    required this.initialColor,
    required this.size,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: colorSelectorDecoration,
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Image.asset('assets/images/transparentBackground50x50.png'),
          Listener(
            onPointerDown: (event) {
              if (checkBit(event.buttons, 0)) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Row(
                        children: [
                          Text(
                            "Pick A Color",
                            style: projectViewerHeaderTextStyle,
                          ),
                        ],
                      ),
                      backgroundColor: appBackgroundColor,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      children: [
                        ColorPickerBody(
                          colorHistory: colorHistory,
                          onColorHistoryChanged: onColorHistoryChanged,
                          initialColor: initialColor,
                          onValueChanged: onColorChanged,
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Container(
              color: initialColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPickerBody extends StatefulWidget {
  final Color initialColor;
  final Function(Color color) onValueChanged;
  final List<Color> colorHistory;
  final Function(List<Color> colorHistory) onColorHistoryChanged;
  const ColorPickerBody({
    Key? key,
    required this.initialColor,
    required this.onValueChanged,
    required this.onColorHistoryChanged,
    required this.colorHistory,
  }) : super(key: key);

  @override
  _ColorPickerBodyState createState() => _ColorPickerBodyState();
}

class _ColorPickerBodyState extends State<ColorPickerBody> {
  HSVColor newColor = HSVColor.fromColor(Colors.black);
  @override
  void initState() {
    super.initState();
    newColor = HSVColor.fromColor(widget.initialColor);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HueWheel(
                initialColor: newColor.toColor(),
                onValueChanged: (hue, sat) {
                  setState(() {
                    newColor = newColor.withHue(hue).withSaturation(sat);
                  });
                },
              ),
              const SizedBox(
                width: 16,
              ),
              BrightnessSlider(
                initialColor: newColor.toColor(),
                onValueChanged: (brightness) {
                  setState(() {
                    newColor = newColor.withValue(brightness);
                  });
                },
              ),
              const SizedBox(
                width: 16,
              ),
              AlphaSlider(
                initialColor: newColor.toColor(),
                onValueChanged: (alpha) {
                  setState(() {
                    newColor = newColor.withAlpha(alpha);
                  });
                },
              ),
              if (widget.colorHistory.isNotEmpty)
                const SizedBox(
                  width: 16,
                ),
              if (widget.colorHistory.isNotEmpty)
                ColorHistory(
                  colorHistory: widget.colorHistory,
                  onColorHistoryChanged: widget.onColorHistoryChanged,
                  onColorSelected: (color) {
                    setState(() {
                      newColor = HSVColor.fromColor(color);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          SelectableText(
            "HEX: #${newColor.toColor().red.toRadixString(16).toUpperCase().padLeft(2, '0')}${newColor.toColor().green.toRadixString(16).toUpperCase().padLeft(2, '0')}${newColor.toColor().blue.toRadixString(16).toUpperCase().padLeft(2, '0')}${newColor.toColor().alpha.toRadixString(16).toUpperCase().padLeft(2, '0')}",
            style: defaultTextStyle.copyWith(fontSize: 16, color: Colors.grey.shade200),
          ),
          SelectableText(
            "R: ${newColor.toColor().red}  G: ${newColor.toColor().green}  B: ${newColor.toColor().blue}  A: ${newColor.toColor().alpha}",
            style: defaultTextStyle.copyWith(fontSize: 16, color: Colors.grey.shade200),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Spacer(),
              TextButton(
                style: iconTextButtonStyle,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cancel",
                    style: defaultTextStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              TextButton(
                style: highlightedIconTextButtonStyle,
                onPressed: () {
                  widget.onValueChanged(newColor.toColor());
                  List<Color> newCH = widget.colorHistory.toList();
                  if (newCH.isNotEmpty && newCH.any((element) => element == newColor.toColor())) {
                    newCH.removeWhere((element) => element == newColor.toColor());
                  }
                  if (newCH.isEmpty || newCH.first != newColor.toColor()) {
                    newCH.insert(0, newColor.toColor());
                  }
                  if (newCH.length > 20) {
                    newCH = newCH.sublist(0, 20);
                  }
                  widget.onColorHistoryChanged(newCH);
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Apply",
                    style: defaultTextStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HueWheel extends StatefulWidget {
  final Color initialColor;
  final Function(double hue, double sat) onValueChanged;

  const HueWheel({
    Key? key,
    required this.initialColor,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  _HueWheelState createState() => _HueWheelState();
}

class _HueWheelState extends State<HueWheel> {
  Offset cpos = Offset.zero;
  HSVColor hsv = HSVColor.fromColor(Colors.black);
  double hue = 0;
  double sat = 0;
  double val = 0;
  double alpha = 0;
  int brightness = 0;

  @override
  void initState() {
    super.initState();
    hsv = HSVColor.fromColor(widget.initialColor);
    hue = hsv.hue;
    sat = hsv.saturation;
    val = hsv.value;
    alpha = hsv.alpha;
    brightness = (val * 255).toInt();
    cpos = Offset(cos(vm.radians(hue)) * sat, sin(vm.radians(hue)) * sat);
    cpos = cpos.scale(128, 128);
  }

  void updateColorFromOffset() {
    Offset scaledpos = cpos.scale(1 / 128, 1 / 128);

    double newHue = vm.degrees((scaledpos.direction + (2 * pi))) % 360;
    double newSat = scaledpos.distance;
    hsv = HSVColor.fromAHSV(alpha, newHue, newSat, val);
    widget.onValueChanged(newHue, newSat);
  }

  @override
  Widget build(BuildContext context) {
    hsv = HSVColor.fromColor(widget.initialColor);
    val = hsv.value;
    hue = hsv.hue;
    sat = hsv.saturation;
    brightness = (val * 255).toInt();
    cpos = Offset(cos(vm.radians(hue)) * sat, sin(vm.radians(hue)) * sat);
    cpos = cpos.scale(128, 128);
    return SizedBox(
      width: 256,
      height: 256,
      child: Stack(
        children: [
          SizedBox(
            width: 256,
            child: Listener(
              onPointerDown: (event) {
                if (checkBit(event.buttons, 0)) {
                  Offset clickPos = event.localPosition - const Offset(128, 128);
                  if (clickPos.distance <= 128) {
                    setState(() {
                      cpos = clickPos;
                      updateColorFromOffset();
                    });
                  }
                }
              },
              onPointerMove: (event) {
                if (checkBit(event.buttons, 0)) {
                  Offset clickPos = event.localPosition - const Offset(128, 128);
                  if (clickPos.distance <= 128) {
                    setState(() {
                      cpos = clickPos;
                      updateColorFromOffset();
                    });
                  }
                }
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(128),
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(Color.fromRGBO(brightness, brightness, brightness, 1), BlendMode.multiply),
                  child: Image.asset(
                    "assets/images/huecircle.png",
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 120.5 + cpos.dx,
            top: 120.5 + cpos.dy,
            child: Listener(
              onPointerMove: (event) {
                if (checkBit(event.buttons, 0)) {
                  setState(() {
                    Offset npos = cpos + event.localDelta;
                    if (npos.scale(1 / 128, 1 / 128).distance <= 1 && npos.scale(1 / 128, 1 / 128).distance >= 0) {
                      cpos = npos;
                    }
                    updateColorFromOffset();
                  });
                }
              },
              child: Stack(
                children: [
                  Icon(
                    Icons.circle,
                    size: 15,
                    color: hsv.toColor(),
                  ),
                  Icon(
                    Icons.circle_outlined,
                    size: 15,
                    color: val > .5 ? Colors.black : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlphaSlider extends StatefulWidget {
  final Color initialColor;
  final Function(double alpha) onValueChanged;
  const AlphaSlider({Key? key, required this.initialColor, required this.onValueChanged}) : super(key: key);

  @override
  _AlphaSliderState createState() => _AlphaSliderState();
}

class _AlphaSliderState extends State<AlphaSlider> {
  HSVColor hsv = HSVColor.fromColor(Colors.black);
  double sliderPos = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    hsv = HSVColor.fromColor(widget.initialColor);
    sliderPos = 250 - (hsv.alpha * 250);
    return SizedBox(
      width: 25,
      height: 256,
      child: Listener(
        onPointerDown: (event) {
          if (checkBit(event.buttons, 0)) {
            double newSliderPos = event.localPosition.dy;
            setState(() {
              if (newSliderPos >= 0 && newSliderPos <= 250) {
                hsv = hsv.withAlpha((250 - newSliderPos) / 250);
                sliderPos = newSliderPos;
                widget.onValueChanged(hsv.alpha);
              }
            });
          }
        },
        onPointerMove: (event) {
          if (checkBit(event.buttons, 0)) {
            double newSliderPos = event.localPosition.dy;
            setState(() {
              if (newSliderPos >= 0 && newSliderPos <= 250) {
                hsv = hsv.withAlpha((250 - newSliderPos) / 250);
                sliderPos = newSliderPos;
                widget.onValueChanged(hsv.alpha);
              }
            });
          }
        },
        child: Stack(
          children: [
            SizedBox(
              width: 25,
              height: 256,
              child: Image.asset(
                'assets/images/transparentBackground50x50.png',
                repeat: ImageRepeat.repeatY,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              width: 25,
              height: 256,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hsv.toColor().withOpacity(1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: sliderPos,
              child: Container(
                width: 25,
                height: 10,
                decoration: BoxDecoration(border: Border.all(color: hsv.value >= .5 ? Colors.black : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BrightnessSlider extends StatefulWidget {
  final Color initialColor;
  final Function(double brightness) onValueChanged;
  const BrightnessSlider({Key? key, required this.initialColor, required this.onValueChanged}) : super(key: key);

  @override
  _BrightnessSliderState createState() => _BrightnessSliderState();
}

class _BrightnessSliderState extends State<BrightnessSlider> {
  HSVColor hsv = HSVColor.fromColor(Colors.black);
  double sliderPos = 0;

  @override
  Widget build(BuildContext context) {
    hsv = HSVColor.fromColor(widget.initialColor);
    sliderPos = 250 - (hsv.value * 250);
    return SizedBox(
      width: 25,
      height: 256,
      child: Listener(
        onPointerDown: (event) {
          if (checkBit(event.buttons, 0)) {
            double newSliderPos = event.localPosition.dy;
            setState(() {
              if (newSliderPos >= 0 && newSliderPos <= 250) {
                hsv = hsv.withAlpha((250 - newSliderPos) / 250);
                sliderPos = newSliderPos;
                widget.onValueChanged(hsv.alpha);
              }
            });
          }
        },
        onPointerMove: (event) {
          if (checkBit(event.buttons, 0)) {
            double newSliderPos = event.localPosition.dy;
            setState(() {
              if (newSliderPos >= 0 && newSliderPos <= 250) {
                hsv = hsv.withValue((250 - newSliderPos) / 250);
                sliderPos = newSliderPos;
                widget.onValueChanged(hsv.value);
              }
            });
          }
        },
        child: Stack(
          children: [
            Container(
              width: 25,
              height: 256,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hsv.withValue(1).toColor().withOpacity(1),
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: sliderPos,
              child: Container(
                width: 25,
                height: 10,
                decoration: BoxDecoration(border: Border.all(color: hsv.value >= .5 ? Colors.black : Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Color History idea by Sceek (Jonas) thenks <3
class ColorHistory extends StatefulWidget {
  final List<Color> colorHistory;
  final Function(List<Color> colorHistory) onColorHistoryChanged;
  final Function(Color color) onColorSelected;
  const ColorHistory({
    Key? key,
    required this.onColorSelected,
    required this.onColorHistoryChanged,
    required this.colorHistory,
  }) : super(key: key);

  @override
  _ColorHistoryState createState() => _ColorHistoryState();
}

class _ColorHistoryState extends State<ColorHistory> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 256,
      child: ListView.builder(
        itemCount: widget.colorHistory.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Container(
              width: 25,
              height: 25,
              decoration: colorSelectorDecoration,
              child: Stack(
                children: [
                  Image.asset('assets/images/transparentBackground50x50.png'),
                  Listener(
                    onPointerDown: (event) {
                      if (checkBit(event.buttons, 0)) {
                        widget.onColorSelected(widget.colorHistory[index]);
                      }
                    },
                    child: Container(
                      color: widget.colorHistory[index],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
