class CollectionGroup {
  CollectionGroup({required this.collections});
  final List<Collection> collections;

  factory CollectionGroup.fromJson(Map<String, dynamic> data) {
    final collections = data['collections'].map<Collection>((collection) =>
      Collection.toCollectionGroup(collection as Map<String, dynamic>)).toList() as List<Collection>;
    return CollectionGroup(collections: collections);
  }
}

class Collection {
  Collection(
      {required this.collectionName,
      required this.requestGroups,
      required this.environments});
  final String collectionName;
  final List<RequestGroup> requestGroups;
  final List<Environment> environments;

  factory Collection.fromCollectionGroup(
      CollectionGroup data, String collectionToSelect) {
    final collectionName = data.collections
        .firstWhere((e) => e.collectionName == collectionToSelect)
        .collectionName;
    final requestGroups = data.collections
        .firstWhere((e) => e.collectionName == collectionToSelect)
        .requestGroups;
    final environments = data.collections
        .firstWhere((e) => e.collectionName == collectionToSelect)
        .environments;
    return Collection(
        collectionName: collectionName,
        requestGroups: requestGroups,
        environments: environments);
  }

  factory Collection.toCollectionGroup(Map<String, dynamic> data) {
    final collectionName = data['collectionName'] as String;
    final requestGroups = data['requestGroups'].map<RequestGroup>((requestGroup) =>
            RequestGroup.fromJson(requestGroup as Map<String, dynamic>)).toList()
        as List<RequestGroup>;
    final environments = data['environments']
        .map<Environment>((environment) => Environment.fromJson(environment as Map<String, dynamic>)).toList() as List<Environment>;
    return Collection(
        collectionName: collectionName,
        requestGroups: requestGroups,
        environments: environments);
  }
}

class RequestGroup {
  RequestGroup({required this.requestGroupName, required this.requests});
  final String requestGroupName;
  final List<Request> requests;

  factory RequestGroup.fromJson(Map<String, dynamic> data) {
    final requestGroupName = data['requestGroupName'] as String;
    final requests = data['requests']
        .map<Request>((request) => Request.fromJson(request as Map<String, dynamic>)).toList() as List<Request>;
    return RequestGroup(requestGroupName: requestGroupName, requests: requests);
  }
}

class Request {
  Request(
      {required this.requestName,
      required this.requestMethod,
      required this.requestUrl,
      required this.options});
  final String requestName;
  final String requestMethod;
  final String requestUrl;
  final RequestOptions options;

  factory Request.fromJson(Map<String, dynamic> data) {
    final String requestName = data['requestName'] as String;
    final String requestMethod = data['requestMethod'] as String;
    final String requestUrl = data['requestUrl'] as String;
    final RequestOptions options =
        RequestOptions.fromJson(data['options'] as Map<String, dynamic>);
    return Request(
        requestName: requestName,
        requestMethod: requestMethod,
        requestUrl: requestUrl,
        options: options);
  }
}

class Environment {
  Environment(
      {required this.environmentName, required this.environmentParameters});
  final String environmentName;
  final Map<String, dynamic> environmentParameters;

  factory Environment.fromJson(Map<String, dynamic> data) {
    final environmentName = data['environmentName'] as String?;
    final environmentParameters =
        data['environmentParameters'] as Map<String, dynamic>?;
    return Environment(
        environmentName: environmentName ?? '',
        environmentParameters: environmentParameters ?? {});
  }
}

class RequestOptions {
  RequestOptions(
      {required this.requestQuery,
      required this.requestBody,
      required this.requestHeaders,
      required this.auth});
  final Map<String, dynamic> requestQuery;
  final RequestBody requestBody;
  final Map<String, dynamic> requestHeaders;
  final Auth auth;

  factory RequestOptions.fromJson(Map<String, dynamic> data) {
    final Map<String, dynamic> requestQuery =
        data['query'] as Map<String, dynamic>;
    final RequestBody requestBody =
        RequestBody.fromJson(data['body'] as Map<String, dynamic>);
    final Map<String, dynamic> requestHeaders =
        data['headers'] as Map<String, dynamic>;
    final Auth auth = Auth.fromJson(data['auth'] as Map<String, dynamic>);
    return RequestOptions(
        requestQuery: requestQuery,
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        auth: auth);
  }
}

class RequestBody {
  RequestBody({required this.bodyType, required this.bodyValue});
  final String bodyType;
  final Map<String, dynamic> bodyValue;

  factory RequestBody.fromJson(Map<String, dynamic> data) {
    final bodyType = data['bodyType'] as String?;
    final bodyValue = data['bodyValue'] as Map<String, dynamic>?;
    return RequestBody(
        bodyType: bodyType ?? 'json', bodyValue: bodyValue ?? {"body": ""});
  }
}

class Auth {
  Auth({required this.authType, required this.authValue});
  final String authType;
  final String authValue;

  factory Auth.fromJson(Map<String, dynamic> data) {
    final authType = data['authType'] as String?;
    final authValue = data['authValue'] as String?;
    return Auth(authType: authType ?? '', authValue: authValue ?? '');
  }
}
