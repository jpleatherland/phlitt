import 'package:flutter/material.dart';
import 'package:phlitt/model/collections_model.dart';

Future<void> showRequestOrGroupRenameDialog(
  BuildContext context,
  RequestGroup requestGroup,
  Request? request,
  void Function(RequestGroup, Request?, String, String) callback,
) async {
  final hasRequest = request != null;
  final controller = TextEditingController(
    text: hasRequest ? request.requestName : requestGroup.requestGroupName,
  );

  final result = await showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(hasRequest ? 'Rename Request' : 'Rename Request Group'),
      content: TextFormField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'New name'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) {
              Navigator.pop(context, value);
            }
          },
          child: const Text('Rename'),
        ),
      ],
    ),
  );

  if (result != null) {
    callback(requestGroup, request,
        hasRequest ? 'requestName' : 'requestGroupName', result);
  }
}

Future<void> showCollectionsDialog(
  BuildContext context,
  Collection collection,
  void Function(Collection, String) callback,
) async {
  final controller = TextEditingController(text: collection.collectionName);

  final result = await showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rename Collection'),
      content: TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'New name'),
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) Navigator.pop(context, value);
          },
          child: const Text('Rename'),
        ),
      ],
    ),
  );

  if (result != null) {
    callback(collection, result);
  }
}

Future<void> deleteCollectionDialog(
  BuildContext context,
  CollectionGroup collectionGroup,
  String collectionName,
  String collectionId,
  void Function(String) callback,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Delete "$collectionName"?'),
      content: const Text('Are you sure you want to delete this collection?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    callback(collectionId);
  }
}

Future<void> renameEnvironmentDialog(
  BuildContext context,
  Environment environment,
  void Function(Environment, String) callback,
) async {
  final controller = TextEditingController(text: environment.environmentName);

  final result = await showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Rename Environment'),
      content: TextFormField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'New name'),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final value = controller.text.trim();
            if (value.isNotEmpty) Navigator.pop(context, value);
          },
          child: const Text('Rename'),
        ),
      ],
    ),
  );

  if (result != null) {
    callback(environment, result);
  }
}

Future<void> deleteRequestGroupDialog(
  BuildContext context,
  Collection collection,
  String requestGroupName,
  String requestGroupId,
  void Function(Collection, String) callback,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Delete "$requestGroupName"?'),
      content: const Text('This will permanently delete the request group.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    callback(collection, requestGroupId);
  }
}

Future<void> deleteRequestDialog(
  BuildContext context,
  RequestGroup requestGroup,
  String requestName,
  String requestId,
  void Function(RequestGroup, String) callback,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Delete "$requestName"?'),
      content: const Text('This will permanently delete the request.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    callback(requestGroup, requestId);
  }
}

Future<void> deleteEnvironmentDialog(
  BuildContext context,
  Collection collection,
  String environmentName,
  String environmentId,
  void Function(Collection, String) callback,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Delete "$environmentName"?'),
      content: const Text('Are you sure you want to delete this environment?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    callback(collection, environmentId);
  }
}
