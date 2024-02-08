import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'bndbox.dart';
import 'cameraWidget.dart';
import 'package:camera/camera.dart';

import 'models.dart';

class DetectionView extends StatefulWidget {
  const DetectionView({super.key, required this.cameras});
  final List<CameraDescription> cameras;

  @override
  State<DetectionView> createState() => _DetectionViewState();
}

class _DetectionViewState extends State<DetectionView> {
  var _model= ssd;
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
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
          CameraWidget(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          BndBox(
              _recognitions == null ? [] : _recognitions!,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
        ],
      ),
    );
  }
}
