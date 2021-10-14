import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:impaqt/camera_widget.dart';
import 'package:impaqt/new_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum CameraMode {
  PhotosMode,
  VideoMode,
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cameras;
  bool value = false;
  int id;

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      setState(() {
        cameras = value;
      });
    });
  }

  ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:120),
                Image.asset('assets/netas.jpg'),
                SizedBox(height:80),
                Container(alignment: Alignment.center,child: Transform.rotate(angle: pi/2,child: Image.asset('assets/right-arrow.png',height: 120,))),
                SizedBox(height: 60,),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff009688)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CameraWidget(cameras: cameras)));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Open Camera',style: TextStyle(fontSize: 24),),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff009688)),
                    onPressed: () async{
                      var file = await _imagePicker.pickImage(source: ImageSource.gallery);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NewImage(image: File(file.path),timeStamp:DateTime.now().millisecondsSinceEpoch.toString()))).then((value) {
                        if(value){
                          showDialog(context: context, builder: (context)=> AlertDialog(content: Text('Success'),));
                        }
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('My Files',style: TextStyle(fontSize: 24),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
