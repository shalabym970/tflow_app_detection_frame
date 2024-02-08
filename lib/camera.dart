import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;
import 'package:flutter_tflite/flutter_tflite.dart';

typedef void Callback(List<dynamic> list, int h, int w);

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;

  CameraScreen({required this.cameras, required this.setRecognitions});

  @override
  _CameraScreenState createState() => new _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? cameraController;
  bool isDetecting = false;



  Future<void> initCamera() async {
    try {
      if (widget.cameras.isEmpty) {
        print('No camera is found');
        return;
      }
      cameraController =
          CameraController(widget.cameras[0], ResolutionPreset.high);
      await cameraController!.initialize();
      if (mounted) {
        setState(() {
          cameraController!.startImageStream((img) {
            if (!isDetecting) {
              isDetecting = true;
              int startTime = new DateTime.now().millisecondsSinceEpoch;

              Tflite.runModelOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                if(recognitions!.isNotEmpty) {
                  String label = recognitions.first['label'];
                  print("=========== label  : $label ===========");
                  print("=========== recognitions  : ${recognitions.toString()} ===========");
                  widget.setRecognitions(recognitions, img.height, img.width);
                }
                print("Detection took ${endTime - startTime}");



                isDetecting = false;
              });
            }
          });
        });
      } else {
        return;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing camera: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();

    initCamera();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    Size? tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = cameraController!.value.previewSize;
    var previewH = math.max(tmp!.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(cameraController!),
    );
  }
}
