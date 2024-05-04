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
        authValue =
            replacePlaceholders(request.options.auth.authValue, environment);
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
    headers.addAll(request.options.requestHeaders
        .map((key, value) => MapEntry(key, value.toString())));
    
    String encodedBody = '';
    if(request.options.requestBody.bodyType == 'application/json'){
      encodedBody = jsonEncode(jsonDecode(request.options.requestBody.bodyValue));
    } else {
      encodedBody = request.options.requestBody.bodyValue;
    }

    switch (request.requestMethod) {
      case 'GET':
        getRequest(
            parsedUrl, encodedBody, headers, updateResponse);
        break;
      case 'POST':
        postRequest(
            parsedUrl, encodedBody, headers, updateResponse);
        break;
      case 'PUT':
        putRequest(
            parsedUrl, encodedBody, headers, updateResponse);
        break;
      case 'DELETE':
        deleteRequest(parsedUrl, updateResponse);
      default:
        break;
    }
  }

  void getRequest(Uri requestUrl, String requestBody,
      Map<String, String> headers, Function updateResponse) async {
    http.Request request = http.Request('GET', requestUrl)
      ..headers.addAll(headers);
    request.body = requestBody;
    http.StreamedResponse response = await request.send();
    if(response.statusCode > 399){
      updateResponse({
        'statusCode': response.statusCode,
        'body': {'error': await response.stream.bytesToString()}
      });
    }
    updateResponse({
      'statusCode': response.statusCode,
      'body': await jsonDecode(await response.stream.bytesToString())
    });
  }

  void postRequest(Uri requestUrl, String requestBody,
      Map<String, String> requestHeaders, Function updateResponse) async {
    http.Response response = await http.post(requestUrl,
        body: requestBody, headers: requestHeaders);
    if(response.statusCode > 399){
      updateResponse({
        'statusCode': response.statusCode,
        'body': {'error': response.body}
      });
    }
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void putRequest(Uri requestUrl, String requestBody,
      Map<String, String> requestHeaders, Function updateResponse) async {
    http.Response response = await http.put(requestUrl,
        body: requestBody, headers: requestHeaders);
    if(response.statusCode > 399){
      updateResponse({
        'statusCode': response.statusCode,
        'body': {'error': response.body}
      });
    }
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void deleteRequest(Uri requestUrl, Function updateResponse) async {
    http.Response response = await http.delete(requestUrl);
    if(response.statusCode > 399){
      updateResponse({
        'statusCode': response.statusCode,
        'body': {'error': response.body}
      });
    }
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
