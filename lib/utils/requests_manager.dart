import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qapic/model/collections_model.dart';

class RequestsManager {
  void submitRequest(
      Request request, Function updateResponse, Environment? environment) {
    String updatedUrl = request.requestUrl;
    String authValue = request.options.auth.authValue;
    if (environment != null) {
      try {
        updatedUrl = replacePlaceholders(request.requestUrl, environment);
        authValue = replacePlaceholders(request.options.auth.authValue, environment);
      } catch (error) {
        throw const FormatException('Environment parameter not found');
      }
    }
    Uri requestUrl = Uri.parse(updatedUrl);
    String currentScheme = requestUrl.scheme;
    String currentHost = requestUrl.host;
    int currentPort = requestUrl.port;
    List<String> splitPath = requestUrl.path.split('/').sublist(1);
    List<dynamic> updatedPath = [];
    for (var element in splitPath) {
      if (element.startsWith(':')) {
        updatedPath.add(
            request.options.requestQuery.pathVariables[element.substring(1)]);
      } else {
        updatedPath.add(element);
      }
    }
    String updatedScheme = currentScheme.isEmpty ? 'https' : currentScheme;
    Map<String, String> currentQueryParams = requestUrl.queryParameters;
    String authType = request.options.auth.authType;
    Uri parsedUrl = Uri(
        scheme: updatedScheme,
        host: currentHost,
        port: currentPort,
        path: updatedPath.join('/'),
        queryParameters: currentQueryParams);
    Map<String, String> headers = {'authorization': '$authType $authValue'};
    switch (request.requestMethod) {
      case 'GET':
        getRequest(parsedUrl, headers, updateResponse);
        break;
      case 'POST':
        postRequest(parsedUrl, request.options.requestBody, updateResponse);
        break;
      case 'PUT':
        putRequest(parsedUrl, request.options.requestBody, updateResponse);
        break;
      case 'DELETE':
        deleteRequest(parsedUrl, updateResponse);
      default:
        break;
    }
  }

  void getRequest(Uri requestUrl, Map<String, String> headers,
      Function updateResponse) async {
    http.Response response = await http.get(requestUrl, headers: headers);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void postRequest(
      Uri requestUrl, RequestBody requestBody, Function updateResponse) async {
    http.Response response = await http.post(requestUrl,
        body: requestBody.bodyValue['body'],
        headers: {'Content-type': 'application/json; charset=UTF-8'});
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void putRequest(
      Uri requestUrl, RequestBody requestBody, Function updateResponse) async {
    http.Response response =
        await http.put(requestUrl, body: requestBody.bodyValue);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void deleteRequest(Uri requestUrl, Function updateResponse) async {
    http.Response response = await http.delete(requestUrl);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  String replacePlaceholders(String input, Environment environment) {
    // match between {{ }} to envParam key and replace with envParam value
    final RegExp pattern = RegExp(r'\{\{([^}]+)\}\}');

    final String updatedUrl = input.replaceAllMapped(
      pattern,
      (match) => environment.environmentParameters[match.group(1)] as String,
    );

    return updatedUrl;
  }
}
