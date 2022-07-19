import 'package:flutter/material.dart';
import '../provider state management/learn003.dart';

void main() {
  runApp(const MaterialApp(
    home: AnotherHomePage(),
  ));
}

class dSliderData extends ChangeNotifier {
  double _dValue = 0;
  double get value => _dValue;
  set value(double newValue) {
    if (newValue != value) {
      _dValue = newValue;
      notifyListeners();
    }
  }
}

final daSliderData = dSliderData();

class dSliderInheritedData extends InheritedNotifier<dSliderData> {
  dSliderInheritedData(
      {required dSliderData daSliderData, required Widget child})
      : super(
          child: child,
          notifier: daSliderData,
        );
  static double valueNotifierFunction(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<dSliderInheritedData>()
          ?.notifier
          ?.value ??
      0.0;
}

class AnotherHomePage extends StatelessWidget {
  const AnotherHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AnotherHomePage"),
      ),
      body: dSliderInheritedData(
        daSliderData: daSliderData,
        child: Builder(builder: (context) {
          return Column(
            children: [
              Slider(
                value: dSliderInheritedData.valueNotifierFunction(context),
                onChanged: (value) {
                  daSliderData.value = value;
                },
              ),
              Row(
                children: [
                  Opacity(
                    opacity:
                        dSliderInheritedData.valueNotifierFunction(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity:
                        dSliderInheritedData.valueNotifierFunction(context),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ].toExpandEqually().toList(),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProviderHomePage()));
                  },
                  child: const Text(
                      'tap to move to provider \n for state management '))
            ],
          );
        }),
      ),
    );
  }
}

extension ExpandEqually on Iterable<Widget> {
  Iterable<Widget> toExpandEqually() => (map((w) => Expanded(child: w)));
}
