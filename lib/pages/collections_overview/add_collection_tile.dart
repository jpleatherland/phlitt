import 'package:flutter/material.dart';

class AddCollectionTile extends StatelessWidget {
  final VoidCallback onAdd;

  const AddCollectionTile({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onAdd,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 80),
              SizedBox(height: 12),
              Text('Add New Collection'),
            ],
          ),
        ),
      ),
    );
  }
}
