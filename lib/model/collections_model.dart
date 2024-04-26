class CollectionGroup {
  CollectionGroup({required this.collections});
  List<Collection> collections;

  factory CollectionGroup.fromJson(Map<String, dynamic> data) {
    List<Collection> collections = data['collections']
        .map<Collection>((collection) =>
            Collection.toCollectionGroup(collection as Map<String, dynamic>))
        .toList() as List<Collection>;
    return CollectionGroup(collections: collections);
  }

  Map<String, dynamic> toJson(CollectionGroup collectionGroup) {
    return {
      'collections': collectionGroup.collections
          .map(
            (e) => e.toJson(),
          )
          .toList(),
    };
  }
}

class Collection {
  Collection(
      {required this.collectionName,
      required this.requestGroups,
      required this.environments});
  String collectionName;
  List<RequestGroup> requestGroups;
  List<Environment> environments;

  factory Collection.fromCollectionGroup(
      CollectionGroup data, String collectionToSelect) {
    String collectionName = data.collections
        .firstWhere((e) => e.collectionName == collectionToSelect)
        .collectionName;
    List<RequestGroup> requestGroups = data.collections
        .firstWhere((e) => e.collectionName == collectionToSelect)
        .requestGroups;
    List<Environment> environments = data.collections
        .firstWhere((e) => e.collectionName == collectionToSelect)
        .environments;
    return Collection(
        collectionName: collectionName,
        requestGroups: requestGroups,
        environments: environments);
  }

  factory Collection.toCollectionGroup(Map<String, dynamic> data) {
    String collectionName = data['collectionName'] as String;
    List<RequestGroup> requestGroups = data['requestGroups']
        .map<RequestGroup>((requestGroup) =>
            RequestGroup.fromJson(requestGroup as Map<String, dynamic>))
        .toList() as List<RequestGroup>;
    List<Environment> environments = data['environments']
        .map<Environment>((environment) =>
            Environment.fromJson(environment as Map<String, dynamic>))
        .toList() as List<Environment>;
    return Collection(
        collectionName: collectionName,
        requestGroups: requestGroups,
        environments: environments);
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionName': collectionName,
      'requestGroups': requestGroups.map((e) => e.toJson()).toList(),
      'environments': environments.map((e) => e.toJson()).toList()
    };
  }
}

class RequestGroup {
  RequestGroup({required this.requestGroupName, required this.requests});
  String requestGroupName;
  List<Request> requests;

  factory RequestGroup.fromJson(Map<String, dynamic> data) {
    String requestGroupName = data['requestGroupName'] as String;
    List<Request> requests = data['requests']
        .map<Request>(
            (request) => Request.fromJson(request as Map<String, dynamic>))
        .toList() as List<Request>;
    return RequestGroup(requestGroupName: requestGroupName, requests: requests);
  }

  Map<String, dynamic> toJson() {
    return {
      'requestGroupName': requestGroupName,
      'requests': requests.map((e) => e._toMap()).toList()
    };
  }
}

class Request {
  Request(
      {required this.requestName,
      required this.requestMethod,
      required this.requestUrl,
      required this.options});
  String requestName;
  String requestMethod;
  String requestUrl;
  RequestOptions options;

  factory Request.fromJson(Map<String, dynamic> data) {
    String requestName = data['requestName'] as String;
    String requestMethod = data['requestMethod'] as String;
    String requestUrl = data['requestUrl'] as String;
    RequestOptions options =
        RequestOptions.fromJson(data['options'] as Map<String, dynamic>);
    return Request(
        requestName: requestName,
        requestMethod: requestMethod,
        requestUrl: requestUrl,
        options: options);
  }

  Map<String, dynamic> _toMap() {
    return {
      'requestName': requestName,
      'requestMethod': requestMethod,
      'requestUrl': requestUrl,
      'options': options.toJson()
    };
  }

  dynamic get(String propertyName) {
    var mapRep = _toMap();
    if (mapRep.containsKey(propertyName)) {
      return mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}

class Environment {
  Environment(
      {required this.environmentName, required this.environmentParameters});
  String environmentName;
  Map<String, dynamic> environmentParameters;

  factory Environment.fromJson(Map<String, dynamic> data) {
    String? environmentName = data['environmentName'] as String?;
    Map<String, dynamic>? environmentParameters =
        data['environmentParameters'] as Map<String, dynamic>?;
    return Environment(
        environmentName: environmentName ?? '',
        environmentParameters: environmentParameters ?? {});
  }

  Map<String, dynamic> toJson() {
    return {
      'environmentName': environmentName,
      'environmentParameters': environmentParameters
    };
  }
}

class RequestOptions {
  RequestOptions(
      {required this.requestQuery,
      required this.requestBody,
      required this.requestHeaders,
      required this.auth});
  RequestQuery requestQuery;
  RequestBody requestBody;
  Map<String, dynamic>? requestHeaders;
  Auth auth;

  factory RequestOptions.fromJson(Map<String, dynamic> data) {
    RequestQuery requestQuery =
        RequestQuery.fromJson(data['requestQuery'] as Map<String, dynamic>);
    RequestBody requestBody =
        RequestBody.fromJson(data['requestBody'] as Map<String, dynamic>);
    Map<String, dynamic>? requestHeaders =
        data['requestHeaders'] as Map<String, dynamic>?;
    Auth auth = Auth.fromJson(data['auth'] as Map<String, dynamic>);
    return RequestOptions(
        requestQuery: requestQuery,
        requestBody: requestBody,
        requestHeaders: requestHeaders,
        auth: auth);
  }

  Map<String, dynamic> toJson() {
    return {
      'requestQuery': requestQuery.toJson(),
      'requestBody': requestBody.toJson(),
      'requestHeaders': requestHeaders,
      'auth': auth
    };
  }
}

class RequestQuery {
  RequestQuery({required this.queryParams, required this.pathVariables});
  Map<String, dynamic> queryParams;
  Map<String, dynamic> pathVariables;

  factory RequestQuery.fromJson(Map<String, dynamic> data) {
    Map<String, dynamic>? queryParams = data['queryParams'] as Map<String, dynamic>?;
    Map<String, dynamic>? pathVariables = data['pathVariables'] as Map<String, dynamic>?;
    return RequestQuery(queryParams: queryParams ?? {"":""}, pathVariables: pathVariables ?? {"":""});
  }

  Map<String, dynamic> toJson(){
    return{'queryParams': queryParams, 'pathVariables': pathVariables};
  }
}

class RequestBody {
  RequestBody({required this.bodyType, required this.bodyValue});
  String bodyType;
  Map<String, dynamic> bodyValue;

  factory RequestBody.fromJson(Map<String, dynamic> data) {
    String? bodyType = data['bodyType'] as String?;
    Map<String, dynamic>? bodyValue =
        data['bodyValue'] as Map<String, dynamic>?;
    return RequestBody(bodyType: bodyType ?? "", bodyValue: bodyValue ?? {});
  }

  Map<String, dynamic> toJson() {
    return {'bodyType': bodyType, 'bodyValue': bodyValue};
  }
}

class Auth {
  Auth({required this.authType, required this.authValue});
  String authType;
  String authValue;

  factory Auth.fromJson(Map<String, dynamic> data) {
    String? authType = data['authType'] as String?;
    String? authValue = data['authValue'] as String?;
    return Auth(authType: authType ?? '', authValue: authValue ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'authType': authType, 'authValue': authValue};
  }
}
