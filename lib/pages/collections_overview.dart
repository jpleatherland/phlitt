import 'package:flutter/material.dart';

class CollectionSelected extends Notification {
  final String val;
  final int index;
  CollectionSelected(this.index, this.val);
}

class CollectionsPage extends StatelessWidget {
  final Map<String, dynamic> collections;
  const CollectionsPage({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
          crossAxisCount: 2,
          children: List<Widget>.generate(
              collections['collections'].length,
              (index) => Column(
                    children: [
                      IconButton(
                          onPressed: () => CollectionSelected(1,collections['collections'][index]['collectionName']).dispatch(context),
                          icon: const Icon(Icons.space_dashboard),
                          iconSize: 80),
                      Text(collections['collections'][index]['collectionName']),
                    ],
                  ))),
    );
  }
}