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

  Widget renderRequestGroups(listToRender) {
    int lastItem = listToRender.length;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: requestGroups.length + 1,
        itemBuilder: (context, index) {
          if (index == lastItem) {
            return TextButton.icon(
              label: const Text('Add Request Group'),
              onPressed: () => _dialogBuilder(context),
              icon: const Icon(Icons.add),
            );
          } else {
            return ExpansionTile(
              title: Text(requestGroups[index]['requestGroupName']),
              children: [renderList(requestGroups[index]['requests'])],
            );
          }
        });
  }

  Widget renderList(listToRender) {
    int lastItem = listToRender.length;
    return ListView.builder(
      itemCount: listToRender.length + 1,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == lastItem) {
          return TextButton.icon(
            label: const Text('Add Request'),
            onPressed: () => print('add request'),
            icon: const Icon(Icons.add),
          );
        } else {
          return TextButton(
            child: Text(listToRender[index]['requestName']),
            onPressed: () => print('Pressed'),
          );
        }
      },
    );
  }

  Future<String?> _dialogBuilder(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Title'),
            content: Text('Replace with input field'),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Disable'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Enable'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
          child: Column(children: [renderRequestGroups(requestGroups)]),
        ),
        const Expanded(
            flex: 5,
            child: Center(
                child: Text('request and response here',
                    style: TextStyle(fontSize: 50))))
      ],
    );
  }
}
