import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:stateful_app/provider%20state%20management/reWriteLearn003.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'learn004.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<BreadCrumbProvider>(
          create: (_) => BreadCrumbProvider()),
      ChangeNotifierProvider<SipJuiceProvider>(
        create: (_) => SipJuiceProvider(),
      ),
      ChangeNotifierProvider<ObjectProvider>(create: (_) => ObjectProvider()),
    ],
    child: MaterialApp(
      home: const ProviderHomePage(),
      routes: {'/new': (context) => const NewBreadCrumbWidget()},
    ),
  ));
}

class BreadCrumb {
  bool isActive;
  final String name;
  final String uuid;

  BreadCrumb({required this.isActive, required this.name})
      : uuid = const Uuid().v4();

  void active() {
    isActive = true;
  }

  @override
  bool operator ==(covariant BreadCrumb other) =>
      isActive == other.isActive && name == other.name;

  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (isActive ? " > " : '');
}

class BreadCrumbProvider extends ChangeNotifier {
  final List<BreadCrumb> _items = [];
  UnmodifiableListView<BreadCrumb> get items => UnmodifiableListView(_items);

  void add(BreadCrumb breadCrumb) {
    for (final item in _items) {
      item.active();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumbWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;

  const BreadCrumbWidget({Key? key, required this.breadCrumbs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map(
        (breadCrumb) {
          return Text(
            breadCrumb.title,
            style: TextStyle(
              color: breadCrumb.isActive ? Colors.blue : Colors.black,
            ),
          );
        },
      ).toList(),
    );
  }
}

class ProviderHomePage extends StatelessWidget {
  const ProviderHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Homepage'),
      ),
      body: Column(
        children: [
          Consumer<BreadCrumbProvider>(
            builder: (context, value, child) =>
                BreadCrumbWidget(breadCrumbs: value.items),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/new');
            },
            child: const Text('Add the bread crumb'),
          ),
          TextButton(
              onPressed: () {
                context.read<BreadCrumbProvider>().reset();
              },
              child: const Text('Reset')),
          MaterialButton(
              child: const Text('click to another mirror version'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const XupHomePage()));
              }),
        ],
      ),
    );
  }
}

class NewBreadCrumbWidget extends StatefulWidget {
  const NewBreadCrumbWidget({Key? key}) : super(key: key);

  @override
  State<NewBreadCrumbWidget> createState() => _NewBreadCrumbWidgetState();
}

class _NewBreadCrumbWidgetState extends State<NewBreadCrumbWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add bread crumb'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: 'Enter a new bread crumb here ...'),
            ),
            TextButton(
                onPressed: () {
                  final text = _controller.text;
                  if (text.isNotEmpty) {
                    final breadCrumb = BreadCrumb(isActive: false, name: text);
                    context.read<BreadCrumbProvider>().add(
                          breadCrumb,
                        );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add')),
          ],
        ));
  }
}
