import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestsManager {
  void submitRequest(Map<String, dynamic> request, Function updateResponse) {
    Uri requestUrl = Uri.parse(request['requestUrl']);
    switch (request['requestMethod']) {
      case 'GET':
        getRequest(requestUrl, request, updateResponse);
        break;
      case 'POST':
        postRequest(requestUrl, request['options']['body'], updateResponse);
        break;
      case 'PUT':
        putRequest(requestUrl, request, updateResponse);
        break;
      case 'DELETE':
        deleteRequest(requestUrl, request, updateResponse);
      default:
        break;
    }
  }

  void getRequest(Uri requestUrl, Map<String, dynamic> request, Function updateResponse) async {
    http.Response response = await http.get(requestUrl);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void postRequest(Uri requestUrl, String requestBody, Function updateResponse) async {
    http.Response response = await http.post(requestUrl, body: requestBody, headers: {'Content-type':'application/json; charset=UTF-8'});
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void putRequest(Uri requestUrl, Map<String, dynamic> request, Function updateResponse) async {
    http.Response response = await http.put(requestUrl, body: request['body']);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }

  void deleteRequest(Uri requestUrl, Map<String, dynamic> request, Function updateResponse) async {
    http.Response response = await http.delete(requestUrl);
    updateResponse({
      'statusCode': response.statusCode,
      'body': json.decode(response.body)
    });
  }
}