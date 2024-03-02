import 'package:flutter/material.dart';

class CollectionChanged extends Notification {
  final String val;
  CollectionChanged(this.val);
}

class CollectionsPage extends StatelessWidget {
  final List collections;
  const CollectionsPage({super.key, required this.collections});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        children: List<Widget>.generate(
            collections[0].length,
            (index) => Column(
                  children: [
                    IconButton(
                        onPressed: () => CollectionChanged(collections[0][index]['collectionName']),
                        icon: const Icon(Icons.space_dashboard),
                        iconSize: 80),
                    Text(collections[0][index]['collectionName']),
                  ],
                )));
  }
}