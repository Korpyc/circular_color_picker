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
    return LayoutBuilder(
      builder: (context, constraints) {
        double radius;

        if (constraints.maxHeight / 2 <= widget.radius ||
            constraints.maxWidth / 2 <= widget.radius) {
          double minSize =
              math.min(constraints.maxHeight, constraints.maxWidth);
          radius = minSize / 2;
        } else {
          radius = widget.radius;
        }

        return ProxyProvider(
          create: (_) => CircularColorPickerStateProvider(
            currentColor: widget.pickerOptions.initialColor,
            radius: radius,
          ),
          update: (
            context,
            value,
            CircularColorPickerStateProvider? previous,
          ) =>
              CircularColorPickerStateProvider(
            currentColor:
                previous?.currentColor ?? widget.pickerOptions.initialColor,
            radius: radius,
          ),
          updateShouldNotify: (
            CircularColorPickerStateProvider previous,
            CircularColorPickerStateProvider current,
          ) =>
              previous.radius != current.radius,
          child: _buildWithBackground(
            child: _buildPickerArea(),
          ),
        );
      },
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
    Color currentColor =
        context.read<CircularColorPickerStateProvider>().currentColor;

    double dotRadians = _degreesToRadians(
      HSVColor.fromColor(currentColor).hue.floorToDouble(),
    );

    _radius = context.watch<CircularColorPickerStateProvider>().radius;

    double dotDistanceFromCenter = (_radius - widget.pickerDotOptions.radius) *
        HSVColor.fromColor(currentColor).saturation;

    _dotPosition = ValueNotifier<Offset>(
      _calculateDotPosition(
        distanceFromCenter: dotDistanceFromCenter,
        angleInRadians: dotRadians,
      ),
    );
    super.didChangeDependencies();
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
        onPanStart: (details) => _handleTouchOnColorfulArea(
          details.localPosition,
          context,
        ),
        onPanUpdate: (details) => _handleTouchOnColorfulArea(
          details.localPosition,
          context,
        ),
        onPanEnd: (_) {
          widget.onColorChange(
            context.read<CircularColorPickerStateProvider>().currentColor,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildColorfullArea(),
            ValueListenableBuilder<Offset>(
              valueListenable: _dotPosition,
              builder: (context, position, child) {
                return _buildPickerDot(
                  position.dx,
                  position.dy,
                  context,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorfullArea() {
    return Stack(
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
      ],
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

  void _handleTouchOnColorfulArea(
    Offset positionOffset,
    BuildContext context,
  ) {
    double deltaX = positionOffset.dx - _radius;
    double deltaY = positionOffset.dy - _radius;

    double realDistanceFromCenter =
        math.sqrt(math.pow(deltaX, 2) + math.pow(deltaY, 2));

    double saturation = realDistanceFromCenter / _radius >= 1
        ? 1
        : realDistanceFromCenter / _radius;

    double theta = math.atan2(deltaX, deltaY);
    double hue = _radiansToDegrees(theta);

    context.read<CircularColorPickerStateProvider>().currentColor =
        HSVColor.fromAHSV(1, hue, saturation, 1).toColor();

    double dotDistanceFromCenter =
        _getDistanceToCenterOfDot(realDistanceFromCenter);

    _dotPosition.value = _calculateDotPosition(
      distanceFromCenter: dotDistanceFromCenter,
      angleInRadians: theta,
    );

    if (!widget.pickerOptions.callOnChangeFunctionOnEnd) {
      widget.onColorChange(
          context.read<CircularColorPickerStateProvider>().currentColor);
    }
  }

  Offset _calculateDotPosition({
    required double distanceFromCenter,
    required double angleInRadians,
  }) {
    double dotCenterX =
        (_radius + distanceFromCenter * math.sin(angleInRadians)) -
            widget.pickerDotOptions.radius;

    double dotCenterY =
        (_radius + distanceFromCenter * math.cos(angleInRadians)) -
            widget.pickerDotOptions.radius;

    return Offset(dotCenterX, dotCenterY);
  }

  double _getDistanceToCenterOfDot(double distanceFromCenter) {
    return math.min(
      distanceFromCenter,
      _radius - widget.pickerDotOptions.radius,
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
