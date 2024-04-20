import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qapic/model/collections_model.dart';

class RequestsManager {
  void submitRequest(Request request, Function updateResponse) {
    Uri requestUrl = Uri.parse(request.requestUrl);
    switch (request.requestMethod) {
      case 'GET':
        getRequest(requestUrl, updateResponse);
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

  void getRequest(Uri requestUrl, Function updateResponse) async {
    http.Response response = await http.get(requestUrl);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void postRequest(Uri requestUrl, RequestBody requestBody, Function updateResponse) async {
    http.Response response = await http.post(requestUrl, body: requestBody.bodyValue?['body'], headers: {'Content-type':'application/json; charset=UTF-8'});
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void putRequest(Uri requestUrl, RequestBody requestBody, Function updateResponse) async {
    http.Response response = await http.put(requestUrl, body: requestBody.bodyValue);
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