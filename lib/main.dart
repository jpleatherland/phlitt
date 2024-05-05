import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

import 'pages/collections_overview.dart';

import 'utils/collections_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double densityAmt = -3.0;
    VisualDensity density =
        VisualDensity(horizontal: densityAmt, vertical: densityAmt);
    return MaterialApp(
      title: 'QAPIC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 100, 193)),
        visualDensity: density,
        useMaterial3: true,
        fontFamily: 'NotoSans',
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
  late Future<CollectionGroup> collectionsFile;

  @override
  void initState() {
    super.initState();
    collectionsFile = widget.collections.readCollectionsFile();
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
                  return CollectionsPage(collectionGroups: snapshot.data!);
                }
              }),
        ));
  }
}
