import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  File file;
  VideoPlayerWidget({Key? key, required this.file}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController controller = VideoPlayerController.file(widget.file);
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
        child: VideoPlayer(controller..play()));
  }
}
