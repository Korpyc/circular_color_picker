import 'package:flutter/material.dart';

class CircularColorPickerOptions {
  /// Chosen color on start
  final Color initialColor;

  /// Fill background with color
  final Color? backgroundColor;

  /// Show background color
  ///
  /// If value backgroundColor is empty, will be shown colorfull sweep gradient background
  final bool showBackground;

  /// Choose behavior of call callback function
  ///
  /// If value callOnChangeFunctionOnEnd is true, onColorChange will be call only on onPanEnd event
  /// if value is false, onColorChange callback will be called on every gesture change
  final bool callOnChangeFunctionOnEnd;

  const CircularColorPickerOptions({
    this.initialColor = const Color(0xffff0000),
    this.showBackground = false,
    this.backgroundColor,
    this.callOnChangeFunctionOnEnd = true,
  });
}
