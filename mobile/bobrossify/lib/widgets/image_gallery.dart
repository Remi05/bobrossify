import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bobrossify/services/image_storage_service.dart';
import 'package:bobrossify/services/firebase_image_storage_service.dart';
import 'package:bobrossify/widgets/image_preview.dart';

class ImageGallery extends StatelessWidget {
  final ImageStorageService _imageStorageService = FirebaseImageStorageService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('images').document('captures').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) 
          return const Text('Loading...');

        Map<String, dynamic> captures = snapshot.data.data;

        if (captures.length == 0) 
          return const Text('No captures yet.');

        List<dynamic> capturesNames = captures.values.toList();                                                   
        capturesNames.sort((name1, name2) => (name1 as String).compareTo(name2 as String));

        return GridView.builder(
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:  3),
          itemCount: captures.length,
          itemBuilder: (context, index) {
            String imageName = capturesNames[index] as String;
            return FutureBuilder(
              future: _imageStorageService.getImageUrl(imageName),
              builder: (context, imageUrlSnapshot) {
                if (!imageUrlSnapshot.hasData) 
                  return Container();

                String imageUrl = imageUrlSnapshot.data;
                return ImagePreview(Image.network(imageUrl));
              }
            );
          }
        );
      },
    );
  }
}