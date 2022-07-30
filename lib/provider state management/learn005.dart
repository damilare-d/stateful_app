import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String now() => DateTime.now().toIso8601String();

@immutable
class Seconds {
  final String value;
  Seconds() : value = now();
}

@immutable
class Minutes {
  final String value;
  Minutes() : value = now();
}

Stream<String> newStream(Duration duration) =>
    Stream.periodic(duration, (_) => now());

class OmeePage extends StatelessWidget {
  const OmeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
        providers: [
          StreamProvider.value(
              value: Stream<Seconds>.periodic(
                  const Duration(seconds: 1), (_) => Seconds()),
              initialData: Seconds()),
          StreamProvider.value(
              value: Stream<Minutes>.periodic(
                  const Duration(seconds: 1), (_) => Minutes()),
              initialData: Minutes()),
        ],
        child: Column(
          children: [
            Row(
              children: [
                SecondsWidget(),
                MinutesWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SecondsWidget extends StatelessWidget {
  const SecondsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seconds = context.watch<Seconds>();
    return Expanded(
        child: Container(
      color: Colors.yellow,
      height: 100,
      child: Text(seconds.value),
    ));
  }
}

class MinutesWidget extends StatelessWidget {
  const MinutesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = context.watch<Minutes>();
    return Expanded(
        child: Container(
      color: Colors.blue,
      height: 100,
      child: Text(minutes.value),
    ));
  }
}
