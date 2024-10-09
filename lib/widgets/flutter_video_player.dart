import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FlutterVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FlutterVideoPlayer({
    super.key,
    required this.videoUrl,
  });

  @override
  FlutterVideoPlayerState createState() => FlutterVideoPlayerState();
}

class FlutterVideoPlayerState extends State<FlutterVideoPlayer> {
  ChewieController? _chewieController;
  VideoPlayerController? videoPlayerController;
  bool isScreenExit = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _chewieController = ChewieController(
      fullScreenByDefault: true,
      errorBuilder: (context, errorMsg) {
        return const Center(
          child: Text(
            "Failed to load video",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
      placeholder: Container(
        color: Colors.transparent,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      materialProgressColors: ChewieProgressColors(
        backgroundColor: Colors.white,
        bufferedColor: Colors.blue,
      ),
      videoPlayerController: videoPlayerController!,
      allowedScreenSleep: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      aspectRatio: 16 / 9,
      autoInitialize: true,
      autoPlay: true,
      showControls: true,
    );

    _chewieController!.enterFullScreen();

    _chewieController!.addListener(() {
      if (_chewieController!.isFullScreen) {
        // print("is full screen");
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        //print("not full screen");
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        ///this is used to prevent multiple screen pops
        if (isScreenExit) {
          videoPlayerController!.pause();
          _chewieController!.pause();
          _chewieController!.removeListener(() {});

          Navigator.pop(context);
          isScreenExit = false;
        }
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController!.dispose();
    videoPlayerController!.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }
}
