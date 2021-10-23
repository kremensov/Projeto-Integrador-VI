import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';


class SpeechPage extends StatefulWidget {
  String result;
  SpeechPage(this.result);

  @override
  _SpeechPageState createState() => _SpeechPageState();
}

enum TtsState {playing, stopped, paused, continued}

class _SpeechPageState extends State<SpeechPage> {
  //String result = "";
  File image;
  ImagePicker imagePicker = ImagePicker();
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;


  @override
  void initState(){
    super.initState();
    imagePicker = ImagePicker();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }
    flutterTts.setStartHandler(() {
      setState(() {
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        ttsState =TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((message) {
      setState(() {
        ttsState = TtsState.stopped;
      });
    });
  }


  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
  }

  Future fala() async {
    await flutterTts.setVolume(0.5);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    if (widget.result != null) {
      if (widget.result.isNotEmpty) {
        var controle = await flutterTts.speak(widget.result);
        if (controle ==1) setState(() => ttsState = TtsState.playing);
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(width: 100),
            Container(
              height: 330,
              width: 320,
              margin: EdgeInsets.only(top: 70),
              padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsets.all(12),
                child: Text(widget.result,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
                ),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/note.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 40, left: 80),
                  color: Colors.white.withOpacity(.2),
                  height: 150,
                    width: 110,
                  child: IconButton(
                    icon: new Icon(Icons.replay_circle_filled, size: 100, color: Colors.green,),
                    onPressed: (){Navigator.pop(context);},
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(top: 40, left: 30),
                  color: Colors.white.withOpacity(.2),
                  height: 150,
                  width: 110,
                  child: IconButton(
                    icon: new Icon(Icons.play_arrow_rounded, size: 100, color: Colors.green,),
                    onPressed: () {fala();},
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
