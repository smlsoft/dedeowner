import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dedeowner/global.dart' as global;
import 'package:intl/intl.dart';

Future<String> clickHouseExecute(String query) async {
  String url = 'https://api2.dev.dedepos.com/orderonlineapi/execute';
  print(query);
  // Create a Map object with the query field
  Map<String, String> requestBody = {
    'query': query,
  };

  // Convert the Map to JSON
  String jsonBody = json.encode(requestBody);

  // Make the HTTP POST request
  var response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    // Request successful
    print('Query executed successfully.');
    // Do something with the response, if needed
    var responseBody = json.decode(response.body);
    return responseBody.toString();
    // ...
  } else {
    // Request failed
    print('Error executing query. Status code: ${response.statusCode}');
  }
  return "";
}

Future<Map<String, dynamic>> clickHouseSelect(String query) async {
  String url = 'https://api2.dev.dedepos.com/orderonlineapi/select';

  // Create a Map object with the query field
  Map<String, String> requestBody = {
    'query': query,
  };

  // Convert the Map to JSON
  String jsonBody = json.encode(requestBody);

  // Make the HTTP POST request
  var response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonBody,
  );

  return json.decode(response.body);
}

void clickHouseUpdate(String query) {
  clickHouseExecute(query);
}
