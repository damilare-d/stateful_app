import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
    home: DApiProvider(api: dApi(), child: const DhomePage()),
  ));
}

class DApiProvider extends InheritedWidget {
  final dApi api;
  final String duuid;

  DApiProvider({Key? key, required this.api, required Widget child})
      : duuid = const Uuid().v4(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant DApiProvider oldWidget) {
    return duuid != oldWidget.duuid;
  }

  static DApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DApiProvider>()!;
  }
}

class DhomePage extends StatefulWidget {
  const DhomePage({Key? key}) : super(key: key);

  @override
  State<DhomePage> createState() => _DhomePageState();
}

class _DhomePageState extends State<DhomePage> {
  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DApiProvider.of(context).api.timeAndDate ?? ''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              'the time and date is ${DApiProvider.of(context).api.timeAndDate ?? 'pls tap button'}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            TimeDateWidget(
              key: _textKey,
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                final api = DApiProvider.of(context).api;
                final timeAndDate = await api.getTimeAndDate();
                setState(() {
                  _textKey = ValueKey(timeAndDate);
                });
              },
              child: const Text('click'),
            )
          ],
        ),
      ),
    );
  }
}

class TimeDateWidget extends StatelessWidget {
  const TimeDateWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = DApiProvider.of(context).api;
    return Text(api.timeAndDate ?? 'Tap the button');
  }
}

class dApi {
  String? timeAndDate;

  Future<String> getTimeAndDate() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then((value) {
      timeAndDate = value;
      return value;
    });
  }
}
