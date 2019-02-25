import 'package:flutter/material.dart';

import 'package:transparent_image/transparent_image.dart';

class ImagePreview extends StatelessWidget {
  final Image _image;

  ImagePreview(this._image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        image: _image.image,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}