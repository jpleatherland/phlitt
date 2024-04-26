import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qapic/model/collections_model.dart';

class RequestsManager {
  void submitRequest(Request request, Function updateResponse) {
    Uri requestUrl = Uri.parse(request.requestUrl);
    switch (request.requestMethod) {
      case 'GET':
        getRequest(request, updateResponse);
        break;
      case 'POST':
        postRequest(requestUrl, request.options.requestBody, updateResponse);
        break;
      case 'PUT':
        putRequest(requestUrl, request.options.requestBody, updateResponse);
        break;
      case 'DELETE':
        deleteRequest(requestUrl, updateResponse);
      default:
        break;
    }
  }

  void getRequest(Request request, Function updateResponse) async {
    Uri currentUrl = Uri.parse(request.requestUrl);
    String currentScheme = currentUrl.scheme;
    String currentHost = currentUrl.host;
    List<String> splitPath = currentUrl.path.split("/").sublist(1);
    List<dynamic> updatedPath = [];
    for (var element in splitPath) {
      if (element.startsWith(":")) {
        updatedPath.add(request.options.requestQuery.pathVariables[element.substring(1)]);
      } else {
        updatedPath.add(element);
      }
    }
    Map<String, String> currentQueryParams = currentUrl.queryParameters;
    String authType = request.options.auth.authType;
    String authValue = request.options.auth.authValue;
    Uri parsedUrl = Uri(
        scheme: currentScheme,
        host: currentHost,
        path: updatedPath.join("/"),
        queryParameters: currentQueryParams);
    http.Response response = await http.get(parsedUrl, headers: {'authorization': '$authType $authValue'});
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
}
