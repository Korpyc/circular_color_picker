import 'package:flutter/material.dart';

class PickerDotOptions {
  /// Radius of picker dot on the screen
  final double radius;

  /// If true, dot can't be moved outside color picker area
  final bool isInner;

  /// Set fixed color for picker dot
  final Color? dotColor;

  /// Set border for picker dot
  final double borderWidth;

  /// Set border color, by default - white color
  final Color borderColor;

  /// Set shadows for the picker dot
  final List<BoxShadow> shadows;

  const PickerDotOptions({
    this.isInner = true,
    this.radius = 16,
    this.borderWidth = 4,
    this.dotColor,
    this.borderColor = Colors.white,
    this.shadows = const [
      BoxShadow(
        color: Colors.black,
        spreadRadius: 0.1,
      ),
    ],
  }) : assert(borderWidth <= radius);
}
