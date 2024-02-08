import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'bndbox.dart';
import 'camera.dart';
import 'dart:math' as math;
import 'package:flutter_tflite/flutter_tflite.dart';

class DetectionView extends StatefulWidget {
  const DetectionView({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<DetectionView> createState() => _DetectionViewState();
}

class _DetectionViewState extends State<DetectionView> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
  }

  @override
  initState() {
    super.initState();
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          CameraScreen(
            cameras: widget.cameras,
            setRecognitions: setRecognitions,
          ),
      //    if (_recognitions.isNotEmpty)
            // BndBox(
            //     _recognitions,
            //     math.max(_imageHeight, _imageWidth),
            //     math.min(_imageHeight, _imageWidth),
            //     screen.height,
            //     screen.width),
        ],
      ),
    );
  }
}
