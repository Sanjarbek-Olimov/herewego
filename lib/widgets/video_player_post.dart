import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPost extends StatefulWidget {
  String file;

  VideoPlayerPost({Key? key, required this.file}) : super(key: key);

  @override
  State<VideoPlayerPost> createState() => _VideoPlayerPostState();
}

class _VideoPlayerPostState extends State<VideoPlayerPost> {
  late VideoPlayerController controller =
      VideoPlayerController.network(widget.file);

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
    return AspectRatio(
      key: const ValueKey(0),
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller
        ..play()),
    );
  }
}
