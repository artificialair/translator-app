import "dart:typed_data";

import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";
import "package:record/record.dart";
import "package:provider/provider.dart";
import "package:collection/collection.dart";
import "package:http/http.dart" as http;

class recordFramework {
  bool _isRecording = false;
  final audioRecorder = AudioRecorder(); 

  recordFramework();

  void toggleRecording() async {
    if (_isRecording) {
      _isRecording = false;
      await stopRecording();
    } else {
      final canRecord = await audioRecorder.hasPermission();

      if (canRecord) {
          _isRecording = true;
          await startRecording();
        }
      }
    }

  //else 
    

  Future<void> startRecording() async {
    try {
      print("BYEEEEEEEEEEEEEE");
      String filePath = "../audiofiles/temp_audio.wav";

      await audioRecorder.start(const RecordConfig(encoder: AudioEncoder.wav), path:filePath);
    }
      catch (err) { 
      print("IT FAILED :( ${err}");
    }
  }

  Future<void> stopRecording() async {
    try {
      print("HIIIIIIIIIIIIIIII");
      String? path = await audioRecorder.stop(); // global variable u init with initState()
      Uint8List bytes = (await http.get(Uri.parse(path!.replaceAll("blob:", "")))).bodyBytes;
      print(bytes);
    }
    catch (err) {
      print("IT FAILED :( ${err}");
    } 
  }
}
