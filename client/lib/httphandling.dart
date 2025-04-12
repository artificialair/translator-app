import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;
class httphandling {
  static Future<http.Response> FetchJSON(String http_endpoint, Map<String, dynamic> json_body) async {
    var http_response = await http.post(
    Uri.parse(http_endpoint),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(json_body),
      ); 
    if (http_response.statusCode == 200) {
      return http_response;
    }
    else {
      throw Exception("Failed to fetch data from the API. Status code: ${http_response.statusCode}");
    }
  }
}
