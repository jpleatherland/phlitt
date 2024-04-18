import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

class CollectionSelected extends Notification {
  final String val;
  final int index;
  CollectionSelected(this.index, this.val);
}

class CollectionsPage extends StatelessWidget {
  final CollectionGroup collectionGroup;
  const CollectionsPage({super.key, required this.collectionGroup});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
          crossAxisCount: 2,
          children: List<Widget>.generate(
              collectionGroup.collections.length,
              (index) => Column(
                    children: [
                      IconButton(
                          onPressed: () => 
                          CollectionSelected(
                                  1,
                                  collectionGroup.collections[index].collectionName)
                              .dispatch(context),
                          icon: const Icon(Icons.space_dashboard),
                          iconSize: 80),
                      Text(collectionGroup.collections[index].collectionName),
                    ],
                  ))),
    );
  }
}
