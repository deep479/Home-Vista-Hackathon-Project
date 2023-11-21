// ignore_for_file: library_private_types_in_public_api, avoid_unnecessary_containers, file_names

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final bool? play;
  final String? url;

  const VideoWidget({super.key, @required this.url, @required this.play});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url!);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            child: Card(
              key: PageStorageKey(widget.url),
              elevation: 5.0,
              child: Chewie(
                key: PageStorageKey(widget.url),
                controller: ChewieController(
                  videoPlayerController: videoPlayerController,
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  autoInitialize: true,
                  looping: false,
                  autoPlay: false,
                  // Errors can occur for example when trying to play a video
                  // from a non-existent URL
                  // errorBuilder: (context, errorMessage) {
                  //   return Center(
                  //     child: Text(
                  //       errorMessage,
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   );
                  // },
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
