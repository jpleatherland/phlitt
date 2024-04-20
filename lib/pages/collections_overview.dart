import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/pages/main_page.dart';
import 'package:qapic/utils/collections_manager.dart';

class CollectionSelected extends Notification {
  final String val;
  final int index;
  CollectionSelected(this.index, this.val);
}

class CollectionsPage extends StatelessWidget with CollectionsManager {
  final CollectionGroup collectionGroups;
  const CollectionsPage({super.key, required this.collectionGroups});

  writeBack(){
    writeCollections(collectionGroups);
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
          crossAxisCount: 2,
          children: List<Widget>.generate(
              collectionGroups.collections.length,
              (index) => Column(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.space_dashboard),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                    collection:
                                        collectionGroups.collections[index],
                                    writeback: writeBack,),
                              ))),
                      Text(collectionGroups.collections[index].collectionName),
                    ],
                  ))),
    );
  }
}
