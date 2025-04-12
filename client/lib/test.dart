import "dart:async";
import "dart:convert";
import "package:sound_stream/sound_stream.dart";
import "package:http/http.dart" as http;
import 'httphandling.dart';

void main() async {
  final url = 'https://translator-backend-kbqg.onrender.com/test_post';
  Map<String, dynamic> json_body = {'name': 'katie'};
  final response = await httphandling.FetchJSON(url, json_body);
  var decoded_response = jsonDecode(response.body);
  decoded_response.forEach((key, value) {
    print('$key : $value'); 
  });
}
