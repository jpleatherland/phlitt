import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final Iterable collection;
  final String collectionName;

  const MainPage(
      {super.key, required this.collection, required this.collectionName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String selectedCollection = '';
  Iterable collection = [];

  @override
  Widget build(BuildContext context) {
    selectedCollection = widget.collectionName;
    collection = widget.collection.where(((element) => element == 'requestGroups'));
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: collection.length,
                itemBuilder: (context, i) {
                  return ExpansionTile(
                      title: Text(collection.elementAt(i).toString()));
                })),
        // NavigationRail(destinations: [
        //   NavigationRailDestination(icon: Icon(Icons.home), label: Text('Hi')),
        //   NavigationRailDestination(icon: Icon(Icons.home), label: Text('Hi1')),
        // ], selectedIndex: 0),
        Expanded(flex: 3, child: Text(selectedCollection))
      ],
    );
  }
}
