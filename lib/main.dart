import 'package:flutter/material.dart';

import 'pages/collections_overview.dart';
import 'pages/main_page.dart';

import 'utils/collections_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QAPIC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 100, 193)),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'QAPIC', collections: CollectionsManager()),
    );
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
  var selectedIndex = 0;
  String selectedCollectionName = '';
  late Future<Map<String, dynamic>> collectionsFile;

  @override
  void initState() {
    super.initState();
    collectionsFile = widget.collections.readCollectionsFile();
  }

  routeSelector(int selectedIndex, Map<String, dynamic> collectionsFile, String selectedCollectionName) {
    
    Iterable selectedCollection = [];

    if (selectedCollectionName != '') {
      selectedCollection = collectionsFile['collections'].where((collection) =>
          collection['collectionName'] == selectedCollectionName);
    }
    switch (selectedIndex) {
      case 0:
        return CollectionsPage(collections: collectionsFile);
      case 1:
        return MainPage(
            collection: selectedCollection,
            collectionName: selectedCollectionName);
      default:
        return CollectionsPage(collections: collectionsFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(widget.title,
              style: TextStyle(color: colorScheme.onPrimary)),
          leading: IconButton.filled(
            onPressed: (() => setState(() {
                  selectedIndex = 0;
                  selectedCollectionName = '';
                })),
            icon: const Icon(Icons.space_dashboard_sharp),
            iconSize: 34,
            color: colorScheme.onPrimary,
          ),
        ),
        body: Center(
            child: FutureBuilder(
                future: collectionsFile,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('Loading...');
                  } else {
                    return NotificationListener<CollectionSelected>(
                        child: routeSelector(selectedIndex, snapshot.data!,
                            selectedCollectionName),
                        onNotification: (notification) {
                          setState(() {
                            selectedIndex = notification.index;
                            selectedCollectionName = notification.val;
                          });
                          return true;
                        });
                  }
                })));
  }
}
