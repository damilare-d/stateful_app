import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) {
      ObjectProvider();
    },
    child: const MaterialApp(
      home: OmePage(),
    ),
  ));
}

@immutable
class BaseObject {
  final String id;
  final String lastUpdated;

  BaseObject()
      : id = const Uuid().v4(),
        lastUpdated = DateTime.now().toIso8601String();

  ///  to make this object to be able to check for equality we write this
  @override
  bool operator ==(covariant BaseObject other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class ExpensiveObject extends BaseObject {}

@immutable
class CheapObject extends BaseObject {}

class ObjectProvider extends ChangeNotifier {
  String? id;
  CheapObject? _cheapObject;
  ExpensiveObject? _expensiveObject;
  StreamSubscription? _cheapObjectStreamSubs;
  StreamSubscription? _expensiveObjectStreamSubs;

  CheapObject? get cheapObject => _cheapObject;
  ExpensiveObject? get expensiveObject => _expensiveObject;

  @override
  void notifyListeners() {
    id = const Uuid().v4();
    super.notifyListeners();
  }

  void start() {
    _cheapObjectStreamSubs = Stream.periodic(
      const Duration(seconds: 1),
    ).listen((_) {
      _cheapObject = CheapObject();
      notifyListeners();
    });
    _expensiveObjectStreamSubs = Stream.periodic(
      const Duration(seconds: 30),
    ).listen((_) {
      _expensiveObject = ExpensiveObject();
      notifyListeners();
    });
  }

  void stop() {
    _cheapObjectStreamSubs?.cancel();
    _expensiveObjectStreamSubs?.cancel();
  }
}

class OmePage extends StatelessWidget {
  const OmePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 4,
                  child: const CheapObjectWidget(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 4,
                  child: const ExpensiveObjectWidget(),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 4,
              child: const ObjectProviderWidget(),
            ),
            Row(children: [
              TextButton(
                onPressed: () {
                  context.read<ObjectProvider>().stop();
                },
                child: const Text('STOP'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ObjectProvider>().start();
                },
                child: const Text('START'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

class CheapObjectWidget extends StatelessWidget {
  const CheapObjectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cheapObject = context.select<ObjectProvider, CheapObject?>(
      (provider) => provider.cheapObject,
    );
    return Container(
      height: 100,
      color: Colors.yellow,
      child: Column(
        children: [
          const Text('Cheap Widget'),
          const Text('Last updated'),
          Text(cheapObject?.lastUpdated ?? ''),
        ],
      ),
    );
  }
}

class ExpensiveObjectWidget extends StatelessWidget {
  const ExpensiveObjectWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expensiveObject = context.select<ObjectProvider, ExpensiveObject?>(
        (provider) => provider.expensiveObject);
    return Container(
      height: 100,
      color: Colors.blue,
      child: Column(
        children: [
          const Text('Expensive Widget'),
          const Text('Last updated'),
          Text(expensiveObject?.lastUpdated ?? '')
        ],
      ),
    );
  }
}

class ObjectProviderWidget extends StatelessWidget {
  const ObjectProviderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ObjectProvider>();

    return Container(
      color: Colors.purpleAccent,
      child: Column(
        children: [
          const Text('Object Provider Widget'),
          const Text('ID'),
          Text(provider.id ?? ''),
        ],
      ),
    );
  }
}
