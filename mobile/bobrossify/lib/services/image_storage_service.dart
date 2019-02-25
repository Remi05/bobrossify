import 'dart:io';

abstract class ImageStorageService {
  Future<void> uploadImage(File image);
  Future<String> getImageUrl(String imageName);
}