import 'package:flutter/material.dart';
import "dart:async";
import "dart:convert";
import "package:record/record.dart";
import "package:provider/provider.dart";
import "package:collection/collection.dart";

class recordFramework {
  bool _isRecording = false;
  late AudioRecorder audioRecorder; 

  void record() async {
    if (_isRecording) {
      await stopRecording();

      _isRecording = false;
      return;
    }
  //else 
    final canRecord = await record.hasPermission();

    if (canRecord) {
        _isRecording = true;
        await record.start(const recordConfig(), path = "" /*path*/);

        final stream = await record.startStream(const recordConfig(encoder: AudioEncoder.pcm16bits));
      }
    }

  Future<void> startRecording() async {
    try {
      String filePath = "../audiofiles/temp_audio.wav";

      await audioRecorder.start(const recordConfig(encoder: AudioEncoder.wav), path:filePath);
    }
      catch (err) { 
      print("IT FAILED :( ${err}");
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecorder.stop(); // global variable u init with initState()

    }
    catch (err) {
      print("IT FAILED :( ${err}");
    } 
}
