import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:qapic/model/collections_model.dart';
import './example_collection.dart';

mixin class CollectionsManager {
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final bool exists = await File('$path/collections.json').exists();
    if (exists) {
      return File('$path/collections.json');
    } else {
      File file = File('$path/collections.json');
      file.writeAsString(collectionTemplate);
      return File('$path/collections.json');
    }
  }

  Future<CollectionGroup> readCollectionsFile() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      final collections = jsonDecode(contents) as Map<String, dynamic>;
      CollectionGroup collectionToReturn =
          CollectionGroup.fromJson(collections);
      return collectionToReturn;
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> writeCollections(CollectionGroup collection) async {
    final file = await _localFile;
    final dataToEncode = collection.toJson(collection);
    final contents = jsonEncode(dataToEncode);

    file.writeAsString(contents);
  }

  void newRequest(RequestGroup requestGroup) {
    requestGroup.requests.add(Request(
        requestName: generateRandomString(),
        requestMethod: 'GET',
        requestUrl: '',
        options: RequestOptions(
            requestBody: RequestBody(bodyType: '', bodyValue: ''),
            requestHeaders: {},
            requestQuery: RequestQuery(pathVariables: {}, queryParams: {}),
            auth: Auth(authType: '', authValue: ''))));
  }

  void deleteRequest(RequestGroup requestGroup, String requestName) {
    requestGroup.requests.removeWhere(
      (element) => element.requestName == requestName,
    );
  }

  void newRequestGroup(Collection collection) {
    collection.requestGroups.add(
        RequestGroup(requestGroupName: generateRandomString(), requests: []));
  }

  void deleteRequestGroup(Collection collection, String requestGroupName) {
    collection.requestGroups
        .removeWhere((element) => element.requestGroupName == requestGroupName);
  }

  void newCollection(CollectionGroup collectionGroup) {
    collectionGroup.collections.add(Collection(
        collectionName: 'New Collection',
        requestGroups: [
          RequestGroup(requestGroupName: 'New Request Group', requests: [])
        ],
        environments: [
          Environment(
              environmentName: generateRandomString(),
              environmentParameters: {})
        ]));
  }

  void deleteCollection(
      CollectionGroup collectionGroup, String collectionName) {
    collectionGroup.collections
        .removeWhere((e) => e.collectionName == collectionName);
  }

  void newEnvironment(Collection collection) {
    collection.environments.add(Environment(
        environmentName: generateRandomString(), environmentParameters: {}));
  }

  void deleteEnvironment(Collection collection, String environmentName) {
    collection.environments
        .removeWhere((e) => e.environmentName == environmentName);
  }

  String generateRandomString() {
    var r = Random();
    return String.fromCharCodes(
        List.generate(10, (index) => r.nextInt(33) + 89));
  }
}
