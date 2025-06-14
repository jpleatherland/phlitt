import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phlitt/model/collections_model.dart';
import 'package:phlitt/utils/url_handler.dart';

class RequestsManager {
  // Helper function to handle API responses
  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    try {
      if (response.statusCode >= 400) {
        return {
          'statusCode': response.statusCode,
          'body': {'error': response.reasonPhrase}
        };
      } else {
        var responseBody = json.decode(response.body);
        return {'statusCode': response.statusCode, 'body': responseBody};
      }
    } catch (err) {
      return {
        'statusCode': response.statusCode,
        'body': {'error': 'Failed to parse response'}
      };
    }
  }

  // Helper function to handle errors
  Map<String, dynamic> _handleError(dynamic error) {
    return {'statusCode': 500, 'body': {'error': error.toString()}};
  }

  // Submit request method
  Future<Map<String, dynamic>> submitRequest(
      Request request, Environment? environment) async {
    String updatedUrl = request.requestUrl;
    String authValue = request.options.auth.authValue;
    if (environment != null) {
      try {
        updatedUrl = replacePlaceholders(request.requestUrl, environment);
        authValue = replacePlaceholders(request.options.auth.authValue, environment);
      } catch (error) {
        return _handleError('Environment parameter not found');
      }
    }

    Uri requestUrl = Uri.parse(updatedUrl);
    String currentScheme = requestUrl.scheme.isEmpty ? 'https' : requestUrl.scheme;
    String currentHost = requestUrl.host;
    int currentPort = requestUrl.port;
    List<String> splitPath = requestUrl.path.split('/').sublist(1);
    List<dynamic> updatedPath = splitPath.map((element) {
      if (element.startsWith(':')) {
        return request.options.requestQuery.pathVariables[element.substring(1)];
      }
      return element;
    }).toList();

    Uri parsedUrl = Uri(
      scheme: currentScheme,
      host: currentHost,
      port: currentPort,
      path: updatedPath.join('/'),
      queryParameters: requestUrl.queryParameters,
    );

    Map<String, String> headers = {
      'authorization': '${request.options.auth.authType} $authValue',
    };
    headers.addAll(request.options.requestHeaders.map((key, value) {
      return MapEntry(key, value.toString());
    }));

    String encodedBody = '';
    if (request.options.requestBody.bodyType == 'application/json') {
      encodedBody = jsonEncode(jsonDecode(request.options.requestBody.bodyValue));
    } else {
      encodedBody = request.options.requestBody.bodyValue;
    }

    try {
      switch (request.requestMethod) {
        case 'GET':
          return await _getRequest(parsedUrl, headers);
        case 'POST':
          return await _postRequest(parsedUrl, encodedBody, headers);
        case 'PUT':
          return await _putRequest(parsedUrl, encodedBody, headers);
        case 'DELETE':
          return await _deleteRequest(parsedUrl, headers);
        default:
          return {'statusCode': 400, 'body': {'error': 'Invalid HTTP Method'}};
      }
    } catch (e) {
      return _handleError(e);
    }
  }

  // GET Request
  Future<Map<String, dynamic>> _getRequest(
      Uri requestUrl, Map<String, String> headers) async {
    try {
      final response = await http.get(requestUrl, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST Request
  Future<Map<String, dynamic>> _postRequest(
      Uri requestUrl, String requestBody, Map<String, String> headers) async {
    try {
      final response = await http.post(requestUrl, body: requestBody, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT Request
  Future<Map<String, dynamic>> _putRequest(
      Uri requestUrl, String requestBody, Map<String, String> headers) async {
    try {
      final response = await http.put(requestUrl, body: requestBody, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE Request
  Future<Map<String, dynamic>> _deleteRequest(
      Uri requestUrl, Map<String, String> headers) async {
    try {
      final response = await http.delete(requestUrl, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }
}
