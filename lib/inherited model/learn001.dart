import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as devtool show log;
import 'package:stateful_app/inherited,%20change%20notifier/learn002.dart';
import '../provider state management/learn003.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => BreadCrumbProvider(),
    child: MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    ),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('my HomePage'),
      ),
      body: AvailableColorsWidget(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        color1 = colors.getRandomElement();
                      });
                    },
                    child: const Text('change color 1')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        color2 = colors.getRandomElement();
                      });
                    },
                    child: const Text('change color 2')),
              ],
            ),
            const ColorWidget(color: AvailableColors.one),
            const ColorWidget(color: AvailableColors.two),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TheHomePage()));
              },
              child: const Text(
                  'tap to move to inherited notifier and change notifier'),
            )
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorsWidget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorsWidget(
      {required this.color1, required this.color2, required Widget child})
      : super(child: child);

  static AvailableColorsWidget of(
    BuildContext context,
    AvailableColors aspect,
  ) {
    return InheritedModel.inheritFrom<AvailableColorsWidget>(context,
        aspect: aspect)!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorsWidget oldWidget) {
    devtool.log('updateShouldNotify');
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  ///if updateShouldNotify is true then updateShouldNotifyDependent would be called
  @override
  bool updateShouldNotifyDependent(covariant AvailableColorsWidget oldWidget,
      Set<AvailableColors> dependencies) {
    devtool.log('updateShouldNotifyDependent');
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

///we then create a widget that is listening to the color
class ColorWidget extends StatelessWidget {
  final AvailableColors color;
  const ColorWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devtool.log('Color1 widget got rebuilt');
        break;
      case AvailableColors.two:
        devtool.log('Color2 widget got rebuilt');
        break;
    }
    final provider = AvailableColorsWidget.of(context, color);
    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}

final List<MaterialColor> colors = [
  Colors.blue,
  Colors.orange,
  Colors.amber,
  Colors.purple,
  Colors.green,
  Colors.lightGreen,
  Colors.deepPurple,
  Colors.red,
  Colors.cyan,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        Random().nextInt(length),
      );
}
