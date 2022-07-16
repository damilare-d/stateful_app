import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: const TheHomePage(),
  ));
}

///the slide data is the state msnsger holding on to the state
class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

/// the inherited notifier would then hold on to the slider data
/// inherited notifier is going to be a subclass that holds on to the change notifier
/// and rebuilds its child when the listenable its listening to calls changeNotifier
/// its going to rebuild its child anytime changeNotifier calls to it
///
/// the inherited notifier would then hold on to the slider data inherited notifier
/// is going to be a subclass that holds on to the change notifier and rebuilds its
/// child when the listenable its listening to calls changeNotifier its going
/// to rebuild its child anytime changeNotifier calls to it
///
/// change notifier holds on to the state inherited notifier rebuilds the child
/// when the value of the change notifier changes,
/// how does d inherited notifier knows its supposed to rebuild a  change notier child
/// through a function the value can be changed after listening to the changeNotifier
///
class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(
          key: key,
          notifier: sliderData,
          child: child,
        );

  //the function for the value to be gotten
  //the function grabs a notifier which is the slider data and also the value
  // and if the whole stuff returns null it returns a 0.0 value

  static double notifyFunction(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class TheHomePage extends StatelessWidget {
  const TheHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(builder: (context) {
          return Column(children: [
            Slider(
                value: 0.0,
                onChanged: (value) {
                  sliderData.value = value;
                }),
            Row(
              children: [
                Opacity(
                  opacity: SliderInheritedNotifier.notifyFunction(context),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: const BoxDecoration(color: Colors.yellow),
                  ),
                ),
                Opacity(
                  opacity: SliderInheritedNotifier.notifyFunction(context),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: const BoxDecoration(color: Colors.blue),
                  ),
                )
              ].expandEqually().toList(),
            ),
          ]);
        }),
      ),
    );
  }
}

// a simple extension to make the container expand
extension ExpandedEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map((w) => Expanded(
        child: w,
      ));
}
