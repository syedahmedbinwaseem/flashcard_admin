import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  String url;
  NetworkImage image;
  ImageView({this.url, this.image});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Hero(
        tag: 'image',
        child: PhotoView(
          loadFailedChild: Center(
            child: Icon(Icons.error),
          ),
          minScale: PhotoViewComputedScale.contained,
          imageProvider: widget.image,
          maxScale: PhotoViewComputedScale.covered,
        ),
      ),
    );
  }
}
