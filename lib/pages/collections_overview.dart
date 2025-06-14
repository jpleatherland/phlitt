import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/pages/main_page.dart';
import 'package:phlitt/utils/collections_manager.dart';
import 'package:phlitt/widgets/rename_dialog.dart' as rd;
import 'package:phlitt/pages/collections_overview/collection_tile.dart';
import 'package:phlitt/pages/collections_overview/add_collection_tile.dart';

class CollectionsPage extends StatefulWidget {
  final CollectionGroup collectionGroups;
  final CollectionsManager manager;

  const CollectionsPage({
    super.key,
    required this.collectionGroups,
    required this.manager,
  });

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  void writeBack() {
    widget.manager.writeCollections(widget.collectionGroups);
    setState(() {}); // Refresh UI after changes
  }

  void updateCollection(Collection collection, String newName) {
    collection.collectionName = newName;
    writeBack();
  }

  void addNewCollection() {
    widget.manager.newCollection(widget.collectionGroups);
    writeBack();
  }

  void deleteCollection(String collectionId) {
    widget.manager.deleteCollection(widget.collectionGroups, collectionId);
    writeBack();
  }

  @override
  Widget build(BuildContext context) {
    final collections = widget.collectionGroups.collections;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 0.75,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: collections.length + 1,
        itemBuilder: (context, index) {
          if (index == collections.length) {
            return AddCollectionTile(onAdd: addNewCollection);
          }

          final collection = collections[index];
          return CollectionTile(
            collection: collection,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MainPage(
                  collection: collection,
                  writeback: writeBack,
                ),
              ),
            ),
            onEdit: () => rd.showCollectionsDialog(
              context,
              collection,
              updateCollection, // Pass the callback to update the collection
            ),
            onDelete: () => rd.deleteCollectionDialog(
              context,
              widget.collectionGroups,
              collection.collectionName,
              collection.collectionId,
              (collectionId) => deleteCollection(
                  collectionId), // Pass deleteCollection with the correct signature
            ),
          );
        },
      ),
    );
  }
}
