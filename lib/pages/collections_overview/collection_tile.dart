import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';

class CollectionTile extends StatelessWidget {
  final Collection collection;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CollectionTile({
    super.key,
    required this.collection,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: 'Open ${collection.collectionName}',
            child: IconButton(
              icon: const Icon(Icons.space_dashboard),
              iconSize: 80,
              onPressed: onTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              collection.collectionName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
            ],
          ),
        ],
      ),
    );
  }
}
