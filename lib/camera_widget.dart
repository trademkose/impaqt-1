import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audio_cache.dart';
import 'package:camera/camera.dart';
import 'package:impaqt/camera_controls.dart';
import 'package:impaqt/home_page.dart';
import 'package:impaqt/new_image.dart';
import 'package:impaqt/permission.dart';
import 'package:impaqt/video_recording_controls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidget extends StatefulWidget {
  CameraWidget({
    Key key,
    @required this.cameras, this.galleryPhoto,
  }) : super(key: key);

  final List<CameraDescription> cameras;
  final galleryPhoto;

  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  CameraMode _cameraMode = CameraMode.PhotosMode;
  CameraDescription _currentSelectedCamera;
  String _fileName;

  static AudioCache audioPlayer = AudioCache(respectSilence: true);

  @override
  void initState() {
    super.initState();
    // To display the current output from the camera,
    // create a CameraController.
    _currentSelectedCamera = widget.cameras.first;
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _currentSelectedCamera,
      // Define the resolution to use - from low - max (highest resolution available).
      ResolutionPreset.max,
      enableAudio: true,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _cameraControls(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  CameraControls _cameraControls(BuildContext context) {
    return CameraControls(
      toggleCameraMode: _toggleCameraMode,
      takePicture: () => _areYouSure(context,widget.galleryPhoto), //_capture(context),
      switchCameras: _switchCamera,
    );
  }

  _areYouSure(context, galleryPhoto) async {
    XFile fileimage = await _controller.takePicture();
    var image = File(fileimage.path);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NewImage(image: image,timeStamp:DateTime.now().millisecondsSinceEpoch.toString())))
        .then((value) {
      if (value != false) {
        _fileName = value;
        _capture(context);
      } else {
        showDialog(context: context, builder: (context)=> AlertDialog(content: Text('Success'),));
      }
    });
  }

  VideoRecordingControls _videoRecordingControls() {
    return VideoRecordingControls(
      onSwitchCamerasBtnPressed: _switchCamera,
      onPauseRecodingBtnPressed: _pauseVideoRecording,
      onStopRecordingBtnPressed: _stopVideoRecording,
      onToggleCameraModeBtnPressed: _toggleCameraMode,
      //onRecordVideoBtnPressed: _startVideoRecording,
      onResumeRecodingBtnPressed: _resumeVideoRecording,
      isRecordingPaused: _controller.value.isRecordingPaused,
      isRecording: _controller.value.isRecordingVideo,
      onRecordVideoBtnPressed: null,
    );
  }

  Future _switchCamera() async {
    // loop through all cameras and find current camera, then move to next
    for (var camera in widget.cameras) {
      if (camera.name == _currentSelectedCamera.name) {
        var x = widget.cameras.indexOf(camera);

        setState(() {
          // if the the last camera, move to first
          if (x == widget.cameras.length - 1) {
            _currentSelectedCamera = widget.cameras.first;
          } else {
            _currentSelectedCamera = widget.cameras[x + 1];
          }
        });

        if (_controller != null) {
          await _controller.dispose();
        }

        _controller = CameraController(
          _currentSelectedCamera,
          ResolutionPreset.max,
          enableAudio: true,
        );

        // If the controller is updated then update the UI.
        _controller.addListener(() {
          if (mounted) setState(() {});
          if (_controller.value.hasError) {
            print('Camera error ${_controller.value.errorDescription}');
          }
        });

        try {
          _controller.initialize();
        } on CameraException catch (e) {
          print(e);
        }
        break;
      }
    }
  }

  void _pauseVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    try {
      await _controller.pauseVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }

    setState(() {});
  }

  void _resumeVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    try {
      await _controller.resumeVideoRecording();
    } on CameraException catch (e) {
      print(e);
      return;
    }

    setState(() {});
  }

  void _stopVideoRecording() async {
    if (_cameraMode != CameraMode.VideoMode) {
      return;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      print(e);
    }

    setState(() {});
  }

  void _toggleCameraMode() {
    setState(() {
      _cameraMode = _cameraMode == CameraMode.PhotosMode
          ? CameraMode.VideoMode
          : CameraMode.PhotosMode;
    });
  }

  void _capture(BuildContext context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    var fileimagepath;
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      final path = join(
        (await getTemporaryDirectory()).path,
        _fileName+'.png',
      );

      XFile fileimage = await _controller.takePicture();

      await audioPlayer.play("shutter.wav");

      // attempt to save to gallery
      bool hasPermission =
          await PermissionsService().hasGalleryWritePermission();

      // request for permision if not given
      if (!hasPermission) {
        bool isGranted =
            await PermissionsService().requestPermissionToGallery();

        if (!isGranted) {
          _showMessage(
            context,
            "Permision Denied. Image was not saved to your Gallery!",
            color: Colors.red,
          );
          return;
        }
      }

      var image1 = await File(fileimage.path).copy(path); //.readAsBytes();
      var image = await File(fileimage.path).readAsBytes();
      var y = Uint8List.fromList(image);
      fileimagepath = image1.path;

      await ImageGallerySaver.saveImage(y);
    } catch (e) {
      _showMessage(
        context,
        "Error! ${e.toString()}",
        color: Colors.red,
      );
    }
    final response = await createAlbum(fileimagepath,context);

    if (response.statusCode == 200) {
      // If the server did return a 201 Created response,
      // then parse the JSON.
      throw Exception('Created!');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Sending Message"),
      ));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Album!');
    }
  }

  Future<http.StreamedResponse> createAlbum(String fileimagepath, BuildContext context) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://20.52.17.56:8037/api/v1/uploadFile'));
    request.files.add(await http.MultipartFile.fromPath('file', fileimagepath));
    //showDialog(context: context, builder: (context)=>AlertDialog(title: Text('Başarılı'),content: Text('İşlem Başarıyla Gerçekleşti'),));
    var res = await request.send();
    final response = await http.Response.fromStream(res);
    print(response.statusCode);
    return res;
  }

  /// Show snakbar message, you can customize text color for errors
  _showMessage(BuildContext context, String message,
      {Color color: Colors.white}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: color),
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }
}
