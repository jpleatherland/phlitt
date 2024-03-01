import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

import 'pages/collections_overview.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QAPIC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 71, 160, 233)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'QAPIC', collections: CollectionsManager()),
    );
  }
}

class CollectionsManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/collection.json');
  }

  Future<Object> readCollectionsFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final collections = jsonDecode(contents);
      return collections;
    } catch (error) {
      return {};
    }
  }

  Future<File> writeCollections(Object collection) async {
    final file = await _localFile;

    return file.writeAsString('$collection');
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.collections});

  final String title;

  final CollectionsManager collections;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  Object collectionsFile = {};
  Object currentCollection = {};

  @override
  void initState() {
    super.initState();
    widget.collections.readCollectionsFile().then((value){
      setState(() {
        collectionsFile = value;
      });
    }).then((value){
      setState(() {
        currentCollection = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    print('current collection: ${currentCollection}');

    // This method is rerun every time setState is called

    Widget page = const CollectionsPage();
    switch (selectedIndex) {
      case 0:
        page = const CollectionsPage();
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title:
              Text(widget.title, style: const TextStyle(color: Colors.white)),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Row(children: [
            NavigationRail(
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Collections')),
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Main Page'))
              ],
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
            NotificationListener<CollectionChanged>(
                child: mainArea,
                onNotification: (n) {
                  setState(() {
                    // currentCollection = collectionsFile[n.val];
                  });
                  return true;
                }),
          ]);
        }));
  }
}
