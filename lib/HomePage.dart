import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'SpeechPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = " ";
  File image;
  ImagePicker imagePicker = ImagePicker();

  captureFromGallery() async{
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null){image = File(pickedFile.path);}
    setState(() {
      image;
      textFromImage();
    });
  }


  captureFromCamera() async {
    PickedFile pickedFile = await imagePicker.getImage(source: ImageSource.camera);
    image = File(pickedFile.path);
    result = "";
    setState(() {
      image;
      textFromImage();
    });
  }

  textFromImage() async {
    final FirebaseVisionImage firebaseVisionImage = FirebaseVisionImage.fromFile(image);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    result = "";

    setState(() {
      for (TextBlock block in visionText.blocks){
        final String txt = block.text;
        for (TextLine line in block.lines){
          for (TextElement element in line.elements){
            result += element.text + " ";
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState(){
    super.initState();
    imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            SizedBox(width: 100),
            Container(
              height: 330,
              width: 320,
              margin: EdgeInsets.only(top:70),
              padding: EdgeInsets.only(left: 28, bottom: 5, right: 18),
              child: SingleChildScrollView(
                child: Padding(padding: EdgeInsets.all(12),
                  child: Text(result,
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
                  margin: EdgeInsets.only(top: 20, left: 40),
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Image.asset('assets/images/pin2.png',
                              height: 240.0,
                              width: 200.0,
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: TextButton(
                          onPressed: (){
                            captureFromCamera();
                          },
                          onLongPress: (){
                            captureFromGallery();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 10),
                            child: image != null ? Image.file(
                                image,
                                width: 160,
                                height: 192,
                                fit: BoxFit.fill): Container(
                              width: 160,
                              height: 192,
                              child:  Icon(
                                Icons.camera_alt,
                                size: 100,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  color: Colors.white.withOpacity(.2),
                  height: 150,
                  width: 110,
                  child: IconButton(
                    icon: new Icon(Icons.record_voice_over,
                      size: 100,
                      color: Colors.green,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> SpeechPage(result)),);
                      },
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