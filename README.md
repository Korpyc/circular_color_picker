
# Circular HSV color picker

Simple, optimized and usefull package to add HSV color picker to your project.

## Getting started

In your pubspec.yaml file within your Flutter Project:
```yaml
dependencies:
  circular_color_picker: <latest_version>
```

## Usage

Just add minimum implementation wherever you want. 

```dart
CircularColorPicker(
            radius: 100,
            onColorChange: (value) {
              //
              // change it as you want
              //
            },
          ),
```

## Additional information

You can customize picker options or picker dot options:

```dart
CircularColorPickerOptions(
        initialColor: const Color(0xffff0000),
        showBackground: false,
        callOnChangeFunctionOnEnd: true,
          ),
```

```dart
PickerDotOptions(
    isInner: true,
    radius: 24,
    borderWidth: 5,
    borderColor = Colors.black,
    this.shadows = const [
      BoxShadow(
        color: Colors.black,
        spreadRadius: 0.5,
      ),
    ],
  )
```

## Further plans

- fixing behavior on windows size changes;
- add brightness bar
- add ability to use few picker dots
- add method to use custom picker dots

P.S. If you have any thoughts about this plugin, I'll be glad to discuss and implement them.
