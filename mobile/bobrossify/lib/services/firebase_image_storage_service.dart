import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import 'package:bobrossify/services/image_storage_service.dart';

class FirebaseImageStorageService implements ImageStorageService {
    final String _imagesFolder = 'images';
    final String _imageCollectionName = 'images';
    final String _capturesDocumentName = 'captures'; 
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
    final Firestore _firestore = Firestore.instance;

    Future<void> uploadImage(File image) async {     
      String imageId = new Uuid().v4();
      String imageName = new DateTime.now().toString();
      var uploadTask = _firebaseStorage.ref().child(_imagesFolder).child(imageName).putFile(image);  
      await uploadTask.onComplete;
       _firestore.collection(_imageCollectionName).document(_capturesDocumentName).updateData({imageId: imageName});
    }

    Future<String> getImageUrl(String imageName) async {
      return (await _firebaseStorage.ref().child(_imagesFolder).child(imageName).getDownloadURL()).toString();
    }
}