import 'package:flutter/material.dart';
import 'package:bobrossify/camera_page.dart';

 main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'BobRossify',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new CameraPage(),
    );
  }
}