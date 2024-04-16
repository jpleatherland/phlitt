import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestsManager {

  void getRequest(Map<String, dynamic> request, Function updateResponse) async {
    Uri requestUrl = Uri.parse(request['requestUrl']);
    http.Response response = await http.get(requestUrl);
    updateResponse(json.decode(response.body));
  }

  void postRequest(Map<String, dynamic> request, Function updateResponse) async {
    Uri requestUrl = Uri.parse(request['requestUrl']);
    http.Response response = await http.post(requestUrl, body: request['body']);
    updateResponse(json.decode(response.body));
  }

}