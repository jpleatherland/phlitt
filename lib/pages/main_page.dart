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
  List requestGroups = [];

  Widget renderList(listToRender) {
    return ListView.builder(
      itemCount: listToRender.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return TextButton(
          child: Text(listToRender[index]['requestName']),
          onPressed: () => print('Pressed'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedCollection = widget.collectionName;
    collection = widget.collection;
    requestGroups = widget.collection.toList()[0]['requestGroups'];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: requestGroups.length,
              itemBuilder: (context, i) {
                return ExpansionTile(
                  title: Text(requestGroups[i]['requestGroupName']),
                  children: [renderList(requestGroups[i]['requests'])],
                );
              }),
        ),
        // NavigationRail(destinations: [
        //   NavigationRailDestination(icon: Icon(Icons.home), label: Text('Hi')),
        //   NavigationRailDestination(icon: Icon(Icons.home), label: Text('Hi1')),
        // ], selectedIndex: 0),
        Expanded(flex: 3, child: Text(selectedCollection))
      ],
    );
  }
}
