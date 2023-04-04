import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:video_player/video_player.dart";

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final VoidCallback onNewVideoPressed;

  const CustomVideoPlayer(
      {required this.video, required this.onNewVideoPressed, Key? key})
      : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  Duration currentPosition = const Duration();
  bool showControl = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initiallizeController();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      initiallizeController();
    }
  }

  initiallizeController() async {
    currentPosition = const Duration();
    videoPlayerController = VideoPlayerController.file(File(widget.video.path));

    await videoPlayerController!.initialize();

    videoPlayerController!.addListener(() {
      setState(() {
        currentPosition = videoPlayerController!.value.position;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const CircularProgressIndicator();
    }
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            showControl = !showControl;
          });
        },
        child: AspectRatio(
            aspectRatio: videoPlayerController!.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(videoPlayerController!),
                AnimatedOpacity(
                    opacity: showControl ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Stack(
                    children: [
                      _Controls(
                        isPlaying: videoPlayerController!.value.isPlaying,
                        onReversPressed: onReversPressed,
                        onPlayPressed: onPlayPressed,
                        onForwardPressed: onForwardPressed,
                      ),
                      _NewVideo(onPressed: widget.onNewVideoPressed),
                      _SliderBottom(
                        currentPosition: currentPosition,
                        maxPosition: videoPlayerController!.value.duration,
                        onValueChanged: onSlideChange,
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void onPlayPressed() {
    setState(() {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      } else {
        videoPlayerController!.play();
      }
      showControl = !showControl;
    });
  }

  void onReversPressed() {
    final currentDuration = videoPlayerController!.value.position;

    Duration position = const Duration();
    if (currentDuration.inSeconds > 3) {
      position = currentDuration - const Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoPlayerController!.value.duration;
    final currentDuration = videoPlayerController!.value.position;

    Duration position = maxPosition;
    if ((currentDuration + Duration(seconds: 3)).inSeconds <
        maxPosition.inSeconds) {
      position = currentDuration + const Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }

  void onSlideChange(double val) {
    videoPlayerController!.seekTo(Duration(seconds: val.toInt()));
  }
}

class _Controls extends StatelessWidget {
  final VoidCallback onPlayPressed;
  final VoidCallback onReversPressed;
  final VoidCallback onForwardPressed;
  final bool isPlaying;

  const _Controls(
      {required this.onPlayPressed,
      required this.onReversPressed,
      required this.onForwardPressed,
      required this.isPlaying,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(.5),
      height: MediaQuery.of(context).size.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          renderIconButton(
              iconData: Icons.rotate_left, onPressed: onReversPressed),
          renderIconButton(
              iconData: isPlaying ? Icons.pause : Icons.play_arrow,
              onPressed: onPlayPressed),
          renderIconButton(
              iconData: Icons.rotate_right, onPressed: onForwardPressed)
        ],
      ),
    );
  }

  Widget renderIconButton(
      {required IconData iconData, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
    );
  }
}

class _NewVideo extends StatelessWidget {
  final VoidCallback onPressed;

  const _NewVideo({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.photo_camera_back),
        color: Colors.white,
        iconSize: 30.0,
      ),
    );
  }
}

class _SliderBottom extends StatelessWidget {
  final Duration currentPosition;
  final Duration maxPosition;
  final ValueChanged<double> onValueChanged;

  const _SliderBottom(
      {required this.currentPosition,
      required this.maxPosition,
      required this.onValueChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(
              '${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, "0")}',
              style: TextStyle(color: Colors.white),
            ),
            Expanded(
              child: Slider(
                value: currentPosition.inSeconds.toDouble(),
                min: 0,
                max: maxPosition.inSeconds.toDouble(),
                onChanged: onValueChanged,
              ),
            ),
            Text(
              '${maxPosition.inMinutes}:${(maxPosition.inSeconds % 60).toString().padLeft(2, "0")}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
