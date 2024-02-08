import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'detection view.dart';
import 'main.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
            child: const Text(ssd),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetectionView(cameras: cameras))))
      ],
    )));
  }
}
