import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:bobrossify/services/image_storage_service.dart';
import 'package:bobrossify/services/firebase_image_storage_service.dart';
import 'package:bobrossify/widgets/image_gallery.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  ImageStorageService imageStorageService = FirebaseImageStorageService();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    imageStorageService.uploadImage(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BobRossify'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: ImageGallery(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}