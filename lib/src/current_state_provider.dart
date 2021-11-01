import 'package:flutter/material.dart';

class CircularColorPickerStateProvider {
  /// Current chosen color
  Color currentColor;

  /// Current radius of color picker widget
  double radius;

  CircularColorPickerStateProvider({
    this.currentColor = const Color(0xFFFF0000),
    this.radius = 100,
  });
}
