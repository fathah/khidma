import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dawa/Functions/addComment.dart';
import 'package:dawa/inc/Const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class RecordVoice extends StatefulWidget {
  String postId;
  RecordVoice({Key? key, required this.postId}) : super(key: key);

  @override
  _RecordVoiceState createState() => _RecordVoiceState();
}

class _RecordVoiceState extends State<RecordVoice> {
  late final WaveController waveController;
  @override
  void initState() {
    super.initState();
    waveController = WaveController();
  }

  @override
  void dispose() {
    waveController.disposeFunc();
    super.dispose();
  }

  bool isRecording = false;
  String recordPlaceholder = "Tap to send voice message";

  startRecording() async {
    setState(() => isRecording = true);
    await waveController.record();
  }

// UPLOAD IMAGE
  uploadVoice(String voicePath) async {
    try {
      File voiceFile = File(voicePath);
      var stream =
          new http.ByteStream(DelegatingStream.typed(voiceFile.openRead()));
      var length = await voiceFile.length();

      var uri = Uri.parse(UPLOAD_URL);
      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(voiceFile.path));
      request.files.add(multipartFile);
      request.fields['api'] = API_KEY;
      request.fields['type'] = 'voice';
      var response = await request.send();

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) async {
        var decode = json.decode(value);
        if (decode['status'] == 'success') {
          String fileLink = decode['file'];
          addComment("Voice Message", widget.postId,
                  fileLink: fileLink, type: "voice")
              .then((value) {
            setState(() {
              recordPlaceholder = "Tap to send voice message";
            });
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  stopRecording() async {
    setState(() {
      isRecording = false;
      recordPlaceholder = "Sending...";
    });
    var path = await waveController.stop();
    if (path != null) uploadVoice(path);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              isRecording ? stopRecording() : startRecording();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(LineIcons.microphone),
                  ),
                  if (!isRecording)
                    Text(
                      recordPlaceholder,
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  Expanded(
                    child: AudioWaveforms(
                        size: Size(Get.width * 0.8, 50.0),
                        waveController: waveController,
                        waveStyle: WaveStyle(
                          backgroundColor: Colors.white,
                          spacing: 8.0,
                          showBottom: false,
                          extendWaveform: true,
                          showMiddleLine: false,
                        )),
                  ),
                  if (isRecording)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(LineIcons.paperPlane),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
