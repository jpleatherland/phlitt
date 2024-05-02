import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qapic/model/collections_model.dart';
import 'package:qapic/pages/main_page.dart';
import 'package:qapic/utils/collections_manager.dart';
import 'package:qapic/widgets/rename_dialog.dart' as rd;

class CollectionsPage extends StatefulWidget with CollectionsManager {
  final CollectionGroup collectionGroups;
  const CollectionsPage({super.key, required this.collectionGroups});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  writeBack() {
    print('writeback');
    widget.writeCollections(widget.collectionGroups);
  }

  void updateCollection(Collection collection, String newCollectionName) {
    writeBack();
    setState(
      () => collection.collectionName = newCollectionName,
    );
  }

  void addNewCollection() {
    widget.newCollection(widget.collectionGroups);
    writeBack();
    setState(() {});
  }

  void deleteCollection(
      CollectionGroup collectionGroup, String collectionName) {
    widget.deleteCollection(collectionGroup, collectionName);
    writeBack();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: widget.collectionGroups.collections.length + 1,
          children: List<Widget>.generate(
              widget.collectionGroups.collections.length + 1,
              (index) => index != widget.collectionGroups.collections.length
                  ? Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.space_dashboard),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainPage(
                                  collection: widget
                                      .collectionGroups.collections[index],
                                  writeback: writeBack,
                                ),
                              )),
                          iconSize: 100,
                        ),
                        Text(widget.collectionGroups.collections[index]
                            .collectionName),
                        Row(
                          children: [
                            const Spacer(flex: 1),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => rd.showCollectionsDialog(
                                      context,
                                      widget.collectionGroups.collections[index],
                                      updateCollection)),
                            ),
                            Expanded(
                              flex:1,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => rd.deleteCollectionDialog(
                                    context,
                                    widget.collectionGroups,
                                    widget.collectionGroups.collections[index]
                                        .collectionName,
                                    deleteCollection),
                              ),
                            ),
                            const Spacer(flex: 1)
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 100,
                            onPressed: () => addNewCollection()),
                        const Text('Add new collection')
                      ],
                    ))),
    );
  }
}
