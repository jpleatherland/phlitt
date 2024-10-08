import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:phlitt/model/collections_model.dart';
import 'package:uuid/uuid.dart';
import './example_collection.dart';

mixin class CollectionsManager {
  static const uuid = Uuid();
  Future<String> get _localPath async {
    final directory = await getApplicationSupportDirectory();
    print(directory);
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
        requestId: uuid.v4().toString(),
        requestName: 'New Request',
        requestMethod: 'GET',
        requestUrl: '',
        options: RequestOptions(
            requestBody: RequestBody(bodyType: '', bodyValue: ''),
            requestHeaders: {},
            requestQuery: RequestQuery(pathVariables: {}, queryParams: {}),
            auth: Auth(authType: '', authValue: ''))));
  }

  void deleteRequest(RequestGroup requestGroup, String requestId) {
    requestGroup.requests.removeWhere(
      (element) => element.requestId == requestId,
    );
  }

  void newRequestGroup(Collection collection) {
    collection.requestGroups.add(RequestGroup(
        requestGroupId: uuid.v4().toString(),
        requestGroupName: 'Request Group',
        requests: []));
  }

  void deleteRequestGroup(Collection collection, String requestGroupId) {
    collection.requestGroups
        .removeWhere((element) => element.requestGroupId == requestGroupId);
  }

  void newCollection(CollectionGroup collectionGroup) {
    collectionGroup.collections.add(Collection(
        collectionId: uuid.v4().toString(),
        collectionName: 'New Collection',
        requestGroups: [
          RequestGroup(
              requestGroupId: uuid.v4().toString(),
              requestGroupName: 'New Request Group',
              requests: [])
        ],
        environments: [
          Environment(
              environmentId: uuid.v4().toString(),
              environmentName: generateRandomString(),
              environmentParameters: {})
        ]));
  }

  void deleteCollection(CollectionGroup collectionGroup, String collectionId) {
    collectionGroup.collections
        .removeWhere((e) => e.collectionId == collectionId);
  }

  void newEnvironment(Collection collection) {
    collection.environments.add(Environment(
        environmentId: uuid.v4().toString(),
        environmentName: 'New Environment',
        environmentParameters: {}));
  }

  void deleteEnvironment(Collection collection, String environmentId) {
    collection.environments
        .removeWhere((e) => e.environmentId == environmentId);
  }

  String generateRandomString() {
    var r = Random();
    return String.fromCharCodes(
        List.generate(10, (index) => r.nextInt(33) + 89));
  }
}
