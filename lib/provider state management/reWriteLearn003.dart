import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stateful_app/provider%20state%20management/learn005.dart';
import 'package:uuid/uuid.dart';

import 'learn004.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) {
      SipJuiceProvider();
    },
    child: const MaterialApp(
      home: XupHomePage(),
    ),
  ));
}

class SipJuice {
  bool isActive;
  final String name;
  final String uuid;

  SipJuice({required this.isActive, required this.name})
      : uuid = const Uuid().v4();

  String get title => name + (isActive ? ' > ' : '');
}

class SipJuiceProvider extends ChangeNotifier {
  final List<SipJuice> _item = [];
  UnmodifiableListView<SipJuice> get items => UnmodifiableListView(_item);

  void add(SipJuice sipJuice) {
    for (final item in _item) {
      item.isActive;
    }
    _item.add(sipJuice);
    notifyListeners();
  }

  void reset() {
    _item.clear();
    notifyListeners();
  }
}

class SipJuiceWidget extends StatelessWidget {
  final UnmodifiableListView<SipJuice> sipJuices;

  const SipJuiceWidget({
    Key? key,
    required this.sipJuices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: sipJuices.map((sipJuice) {
        return Text(
          sipJuice.title,
          style:
              TextStyle(color: sipJuice.isActive ? Colors.blue : Colors.black),
        );
      }).toList(),
    );
  }
}

class XupHomePage extends StatefulWidget {
  const XupHomePage({Key? key}) : super(key: key);

  @override
  State<XupHomePage> createState() => _XupHomePageState();
}

class _XupHomePageState extends State<XupHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taste The Drink'),
      ),
      body: Column(
        children: [
          Consumer<SipJuiceProvider>(
              builder: (context, value, child) =>
                  SipJuiceWidget(sipJuices: value.items)),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddJuice()));
            },
            child: const Text('Add More Juice'),
          ),
          TextButton(
            onPressed: () {
              context.read<SipJuiceProvider>().reset();
            },
            child: const Text('Reset'),
          ),
          MaterialButton(
              child: const Text('click to another mirror version'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const OmePage()));
              }),
        ],
      ),
    );
  }
}

class AddJuice extends StatefulWidget {
  const AddJuice({
    Key? key,
  }) : super(key: key);

  @override
  State<AddJuice> createState() => _AddJuiceState();
}

class _AddJuiceState extends State<AddJuice> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add to Juice'),
        ),
        body: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'sip a juice'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text;
                {
                  if (text.isNotEmpty) {
                    final sipJuice = SipJuice(isActive: false, name: text);
                    context.read<SipJuiceProvider>().add(sipJuice);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
