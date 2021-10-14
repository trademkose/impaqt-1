import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final Function takePicture;
  final Function toggleCameraMode;
  final Function switchCameras;

  const CameraControls({
    Key key,
    @required this.takePicture,
    @required this.toggleCameraMode,
    @required this.switchCameras,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RawMaterialButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 40,
          ),
          shape:  CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.black,
          padding: const EdgeInsets.all(15.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        //SwitchCamerasButton(onSwitchCamerasBtnPressed: switchCameras),
        SizedBox(
          width: 20,
        ),

        RawMaterialButton(
          child: Icon(
            Icons.camera_alt_outlined,
            color: Colors.white,
            size: 60,
          ),
          shape:  CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.black,
          padding: const EdgeInsets.all(15.0),
          onPressed: () {
            takePicture();
          },
        ),
        /*
        SizedBox(
          width: 20,
        ),
        RawMaterialButton(
          child: Icon(
            Icons.videocam,
            color: Colors.black,
          ),
          shape: new CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
          onPressed: () {
            toggleCameraMode();
          },
        ),
         */
      ],
    );
  }
}

class SwitchCamerasButton extends StatelessWidget {
  const SwitchCamerasButton({
    Key key,
    @required this.onSwitchCamerasBtnPressed,
  }) : super(key: key);

  final Function onSwitchCamerasBtnPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        Icons.switch_camera,
        color: Colors.black,
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
      onPressed: () {
        onSwitchCamerasBtnPressed();
      },
    );
  }
}
