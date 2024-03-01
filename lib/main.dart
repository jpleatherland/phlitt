import 'package:flutter/material.dart';

import 'pages/collections_overview.dart';
import 'utils/collections_manager.dart';

void main() {
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.collections});

  final String title;

  final CollectionsManager collections;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title:
              Text(widget.title, style: TextStyle(color: colorScheme.onPrimary)),
          leading: IconButton(
              onPressed: () => setState(() => selectedIndex = 0),
              icon: const Icon(Icons.home_outlined),
              iconSize: 40),
        ),
        body: Center(
            child: FutureBuilder(
                future: widget.collections.readCollectionsFile(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('color: Colors.black,');
                  } else {
                    return CollectionsPage(
                      collections: [snapshot.data],
                    );
                  }
                })));
  }
}
