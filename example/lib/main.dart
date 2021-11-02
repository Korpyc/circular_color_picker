import 'package:flutter/material.dart';

import 'package:circular_color_picker/circular_color_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Color Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Circular Color Picker Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.color_lens)),
              Tab(icon: Icon(Icons.colorize)),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            FirstTab(),
            SecondTab(),
          ],
        ),
      ),
    );
  }
}

class FirstTab extends StatefulWidget {
  const FirstTab({Key? key}) : super(key: key);

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  final ValueNotifier<Color> _chosenColor =
      ValueNotifier(const Color(0xFFFF0000));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: CircularColorPicker(
            radius: 130,
            pickerOptions:
                const CircularColorPickerOptions(showBackground: true),
            onColorChange: (value) {
              //
              // change it as you want
              //
              _chosenColor.value = value;
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ValueListenableBuilder<Color>(
              valueListenable: _chosenColor,
              builder: (context, value, child) => Container(
                height: 20,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: value,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SecondTab extends StatefulWidget {
  const SecondTab({Key? key}) : super(key: key);

  @override
  State<SecondTab> createState() => _SecondTabState();
}

class _SecondTabState extends State<SecondTab> {
  late final ValueNotifier<Color> _chosenColor;
  @override
  void initState() {
    super.initState();
    _chosenColor = ValueNotifier(const Color(0xFFFF0000));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CircularColorPicker(
                radius: 100,
                pickerOptions: const CircularColorPickerOptions(
                  showBackground: true,
                  backgroundColor: Colors.white54,
                  callOnChangeFunctionOnEnd: false,
                ),
                pickerDotOptions: const PickerDotOptions(
                  isInner: false,
                  borderWidth: 8,
                  shadows: [],
                ),
                onColorChange: (value) {
                  //
                  // change it as you want
                  //
                  _chosenColor.value = value;
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder<Color>(
                valueListenable: _chosenColor,
                builder: (context, value, child) => Container(
                  height: 20,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
