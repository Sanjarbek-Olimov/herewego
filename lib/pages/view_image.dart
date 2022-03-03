import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  static const String id = "view_image";
  String url;
  ViewImage({Key? key, required this.url}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: Image.network(widget.url));
  }
}

