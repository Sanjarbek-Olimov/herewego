import 'package:flutter/material.dart';
import 'package:herewego/model/post_model.dart';
import 'package:video_player/video_player.dart';

class ViewImage extends StatefulWidget {
  static const String id = "view_image";
  Post post;

  ViewImage({Key? key, required this.post}) : super(key: key);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  late VideoPlayerController controller =
      VideoPlayerController.network(widget.post.image!);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.post.isVideo
        ? AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller..play()))
        : InteractiveViewer(
            minScale: 0.5,
            maxScale: 5,
            child: Image.network(widget.post.image!));
  }
}
