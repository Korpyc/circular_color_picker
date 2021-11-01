import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:circular_color_picker/src/circular_color_picker_options.dart';
import 'package:circular_color_picker/src/picker_dot_options.dart';
import 'package:circular_color_picker/src/current_state_provider.dart';
import 'package:circular_color_picker/src/picker_dot.dart';

class CircularColorPicker extends StatefulWidget {
  /// Maximun value of radius of color picker widget on the screen
  final double radius;

  /// Setup options of color picker
  final CircularColorPickerOptions pickerOptions;

  /// Setup options of dot of color selection
  final PickerDotOptions pickerDotOptions;

  /// Callback on changed color
  final ValueChanged<Color> onColorChange;

  CircularColorPicker({
    Key? key,
    this.radius = 120,
    this.pickerOptions = const CircularColorPickerOptions(),
    this.pickerDotOptions = const PickerDotOptions(),
    required this.onColorChange,
  })  : assert(pickerDotOptions.radius < radius),
        super(key: key);

  @override
  _CircularColorPickerState createState() => _CircularColorPickerState();
}

class _CircularColorPickerState extends State<CircularColorPicker> {
  static const List<Color> _colors = [
    Color(0xffff0000),
    Color(0xffff00ff),
    Color(0xff0000ff),
    Color(0xff00ffff),
    Color(0xff00ff00),
    Color(0xffffff00),
    Color(0xffff0000)
  ];

  @override
  Widget build(BuildContext context) {
    double? radius;
    Size screenSize = MediaQuery.of(context).size;
    if (screenSize.height / 2 < widget.radius ||
        screenSize.width / 2 < widget.radius) {
      double minSize = math.min(screenSize.height, screenSize.width);
      radius = minSize / 2;
      if (!widget.pickerDotOptions.isInner) {
        radius -= widget.pickerDotOptions.radius;
      }
    }
    return Provider(
      create: (_) => CircularColorPickerStateProvider(
        currentColor: widget.pickerOptions.initialColor,
        radius: radius ?? widget.radius,
      ),
      child: _buildWithBackground(
        child: _buildPickerArea(),
      ),
    );
  }

  Widget _buildWithBackground({required Widget child}) {
    return Container(
      color: widget.pickerOptions.showBackground
          ? widget.pickerOptions.backgroundColor ?? const Color(0xFF212327)
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.pickerOptions.showBackground &&
              widget.pickerOptions.backgroundColor == null)
            Opacity(
              opacity: 0.2,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: SweepGradient(
                    colors: _colors,
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }

  Widget _buildPickerArea() {
    return _ColorPickerArea(
      colors: _colors,
      pickerOptions: widget.pickerOptions,
      pickerDotOptions: widget.pickerDotOptions,
      onColorChange: widget.onColorChange,
    );
  }
}

class _ColorPickerArea extends StatefulWidget {
  final List<Color> colors;
  final CircularColorPickerOptions pickerOptions;
  final PickerDotOptions pickerDotOptions;
  final ValueChanged<Color> onColorChange;
  const _ColorPickerArea({
    required this.colors,
    required this.pickerOptions,
    required this.pickerDotOptions,
    required this.onColorChange,
    Key? key,
  }) : super(key: key);

  @override
  State<_ColorPickerArea> createState() => _ColorPickerAreaState();
}

class _ColorPickerAreaState extends State<_ColorPickerArea> {
  late ValueNotifier<Offset> _dotPosition;
  late double _radius;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Color currentColor =
        context.read<CircularColorPickerStateProvider>().currentColor;
    double dotRadians = _degreesToRadians(HSVColor.fromColor(currentColor).hue);

    _radius = context.read<CircularColorPickerStateProvider>().radius;

    double dotDistanceToCenter =
        (_radius - widget.pickerDotOptions.radius * 2) *
            HSVColor.fromColor(currentColor).saturation;
    final double dotCenterX =
        _radius + dotDistanceToCenter * math.sin(dotRadians);
    final double dotCenterY =
        _radius + dotDistanceToCenter * math.cos(dotRadians);

    _dotPosition = ValueNotifier<Offset>(
      Offset(dotCenterX, dotCenterY),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPickerArea(context);
  }

  Widget _buildPickerArea(BuildContext context) {
    return SizedBox(
      height: _radius * 2,
      width: _radius * 2,
      child: GestureDetector(
        onPanStart: (details) => _handleTouchWheel(
          details.localPosition,
          context,
        ),
        onPanUpdate: (details) => _handleTouchWheel(
          details.localPosition,
          context,
        ),
        onPanEnd: (_) {
          widget.onColorChange(
              context.read<CircularColorPickerStateProvider>().currentColor);
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(
                widget.pickerDotOptions.isInner
                    ? 0
                    : widget.pickerDotOptions.radius,
              ),
              width: _radius * 2,
              height: _radius * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(_radius),
                ),
                gradient: SweepGradient(
                  colors: widget.colors,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 0.3,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(
                widget.pickerDotOptions.isInner
                    ? 0
                    : widget.pickerDotOptions.radius,
              ),
              width: _radius * 2,
              height: _radius * 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(_radius),
                ),
                gradient: const RadialGradient(
                  colors: <Color>[
                    Colors.white,
                    Color(0x00ffffff),
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
            ValueListenableBuilder<Offset>(
              valueListenable: _dotPosition,
              builder: (context, value, child) {
                Color currentColor = context
                    .read<CircularColorPickerStateProvider>()
                    .currentColor;
                double dotRadians =
                    _degreesToRadians(HSVColor.fromColor(currentColor).hue);

                _radius =
                    context.read<CircularColorPickerStateProvider>().radius;

                double dotDistanceToCenter =
                    (_radius - widget.pickerDotOptions.radius * 2) *
                        HSVColor.fromColor(currentColor).saturation;
                final double dotCenterX =
                    _radius + dotDistanceToCenter * math.sin(dotRadians);
                final double dotCenterY =
                    _radius + dotDistanceToCenter * math.cos(dotRadians);

                if (_dotPosition.value != Offset(dotCenterX, dotCenterY)) {
                  _dotPosition.value = Offset(dotCenterX, dotCenterY);
                }

                return _buildPickerDot(
                  value.dx,
                  value.dy,
                  context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleTouchWheel(
    Offset positionOffset,
    BuildContext context,
  ) {
    double deltaX = positionOffset.dx - _radius;
    double deltaY = positionOffset.dy - _radius;

    double realDistanceFromCenter =
        math.sqrt(math.pow(deltaX, 2) + math.pow(deltaY, 2));

    double saturation = realDistanceFromCenter / _radius <= 0.1
        ? 0
        : _calculateSaturation(realDistanceFromCenter / _radius);

    double theta = math.atan2(deltaX, deltaY);
    double hue = _radiansToDegrees(theta);

    context.read<CircularColorPickerStateProvider>().currentColor =
        HSVColor.fromAHSV(1, hue, saturation, 1).toColor();

    double thumbDistanceToCenter =
        _getDistanceToCenterOfDot(realDistanceFromCenter);

    double thumbCenterX = _radius + thumbDistanceToCenter * math.sin(theta);
    double thumbCenterY = _radius + thumbDistanceToCenter * math.cos(theta);

    thumbCenterX -= widget.pickerDotOptions.radius;
    thumbCenterY -= widget.pickerDotOptions.radius;

    _dotPosition.value = Offset(thumbCenterX, thumbCenterY);

    if (!widget.pickerOptions.callOnChangeFunctionOnEnd) {
      widget.onColorChange(
          context.read<CircularColorPickerStateProvider>().currentColor);
    }
  }

  double _calculateSaturation(
    double value,
  ) {
    double saturation = (value * 0.7) + 0.4;
    return saturation >= 1 ? 1 : saturation;
  }

  double _getDistanceToCenterOfDot(double distanceFromCenter) {
    return math.min(
      distanceFromCenter,
      _radius - widget.pickerDotOptions.radius,
    );
  }

  Widget _buildPickerDot(
    double left,
    double top,
    BuildContext context,
  ) {
    return Positioned(
      left: left,
      top: top,
      child: PickerDot(
        chosenColor:
            context.read<CircularColorPickerStateProvider>().currentColor,
        pickerDotOptions: widget.pickerDotOptions,
      ),
    );
  }

  double _radiansToDegrees(double radians) {
    double angle = ((radians + math.pi) / math.pi * 180) + 90;
    if (angle < 0) angle += 360;
    if (angle > 360) angle -= 360;
    return angle;
  }

  double _degreesToRadians(double degrees) {
    // rotate angle to correct value
    degrees -= 180;
    if (degrees >= 0 && degrees <= 270) {
      return (degrees + 90) / 180 * math.pi - math.pi;
    }
    return (degrees - 270) / 180 * math.pi - math.pi;
  }
}
