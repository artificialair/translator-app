import "dart:async";
import "dart:convert";
import "package:record/record.dart";
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

void _record() async {
  if (_isRecording) {
    await _stopRecording();

    setState(() {
      _isRecording = false;
    }
    return;
  }
  //else 
  final canRecord = await record.hasPermission();

  if (canRecord) {
    await record.start(const recordConfig(), path = "" /*path*/);

    final stream = await record.startStream(const recordConfig(encoder: AudioEncoder.pcm16bits));
  }
}

Future<void> _startRecording() async {
  try {
    String filePath = "../audiofiles/temp_audio.wav";

    await _audioRecorder.start(const recordConfig(encoder: AudioEncoder.wav), path:filePath);
  }
  catch (err) { 
    print("IT FAILED :( ${err}");
  }
}

Future<void> _stopRecording() async {
  try {
    String? path = await _audioRecorder.stop(); // global variable u init with initState()

    setState(() {
      _audioPath = path;
    }
  }
  catch (err) {
    print("IT FAILED :( ${err}");
  } 
}
