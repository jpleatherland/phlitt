import 'package:flutter/material.dart';
import 'package:qapic/model/collections_model.dart';

void showDialog(
  BuildContext context,
  RequestGroup requestGroup,
  Request? request,
  void Function(RequestGroup requestGroup, Request? request,
          String valueToUpdate, dynamic value)
      callback,
) {
  bool hasRequest = request?.requestName != null;
  Navigator.of(context).push(DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: const Text("Request Name:"),
          content: TextFormField(
            initialValue: request?.requestName ?? requestGroup.requestGroupName,
            onChanged: (value) => callback(requestGroup, request,
                hasRequest ? 'requestName' : 'requestGroupName', value),
            onFieldSubmitted: (value) {
              callback(requestGroup, request,
                  hasRequest ? 'requestName' : 'requestGroupName', value);
              Navigator.of(context).pop();
            },
          ))));
}

showCollectionsDialog(
  BuildContext context,
  Collection collection,
  void Function(Collection collection, String value) callback,
) {
  TextEditingController controller =
      TextEditingController(text: collection.collectionName);
  Navigator.of(context).push(DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text("Collection Name:"),
            content: Column(
              children: [
                TextFormField(
                    controller: controller,
                    onFieldSubmitted: (value) {
                      callback(collection, value);
                      Navigator.of(context).pop();
                    }),
                IconButton(
                    onPressed: () {
                      callback(collection, controller.text);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.save))
              ],
            ),
          )));
}

deleteCollectionDialog(
  BuildContext context,
  CollectionGroup collectionGroup,
  String collectionName,
  void Function(CollectionGroup collectionGroup, String collectionName) callback,
) {
  Navigator.of(context).push(DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text("Delete Collection $collectionName ?"),
            content: Row(
              children: [
                Expanded(child: IconButton(icon: const Icon(Icons.arrow_back), iconSize: 50,  onPressed:()=> Navigator.of(context).pop())),
                Expanded(
                  child: IconButton(
                    iconSize: 50,
                      onPressed: () {
                        callback(collectionGroup, collectionName);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.delete)),
                )
              ],
            ),
          )));
}
