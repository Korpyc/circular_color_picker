import 'package:flutter/material.dart';

import 'package:circular_color_picker/src/picker_dot_options.dart';

class PickerDot extends StatelessWidget {
  /// Current chosen color
  final Color chosenColor;

  /// Current options of color picker dot
  final PickerDotOptions pickerDotOptions;
  const PickerDot({
    required this.chosenColor,
    required this.pickerDotOptions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: pickerDotOptions.radius * 2,
      height: pickerDotOptions.radius * 2,
      padding: EdgeInsets.all(pickerDotOptions.borderWidth),
      decoration: BoxDecoration(
          color: pickerDotOptions.borderColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              pickerDotOptions.radius,
            ),
          ),
          boxShadow: pickerDotOptions.shadows),
      child: Container(
        decoration: BoxDecoration(
          color: pickerDotOptions.dotColor ?? chosenColor,
          borderRadius: BorderRadius.all(
            Radius.circular(
              pickerDotOptions.radius,
            ),
          ),
        ),
      ),
    );
  }
}
