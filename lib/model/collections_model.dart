class Collection {
  Collection(
      {required this.collectionName,
      required this.requestGroups,
      required this.environments});
  final String collectionName;
  final List<RequestGroup> requestGroups;
  final List<Environment> environments;

  factory Collection.fromJson(Map<String, dynamic> data) {
    final collectionName = data['collectionName'] as String;
    final requestGroups = data['requestGroups'] as List<RequestGroup>;
    final environments = data['environments'] as List<Environment>;
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
    final requests = data['requests'] as List<Request>;
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
    final RequestOptions options = data['options'] as RequestOptions;
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
  final Map<String, dynamic>? environmentParameters;

  factory Environment.fromJson(Map<String, dynamic> data) {
    final String environmentName = data['environmentName'] as String;
    final Map<String, dynamic> environmentParameters =
        data['environmentParameters'] as Map<String, dynamic>;
    return Environment(
        environmentName: environmentName,
        environmentParameters: environmentParameters);
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
    final RequestBody requestBody = data['body'] as RequestBody;
    final Map<String, dynamic> requestHeaders =
        data['headers'] as Map<String, dynamic>;
    final Auth auth = data['auth'] as Auth;
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
    final String bodyType = data['bodyType'] as String;
    final Map<String, dynamic> bodyValue =
        data['bodyValue'] as Map<String, dynamic>;
    return RequestBody(bodyType: bodyType, bodyValue: bodyValue);
  }
}

class Auth {
  Auth({required this.authType, required this.authValue});
  final String authType;
  final String authValue;

  factory Auth.fromJson(Map<String, String> data) {
    final String authType = data['authType'] as String;
    final String authValue = data['authValue'] as String;
    return Auth(authType: authType, authValue: authValue);
  }
}
