import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTLiveDemo extends StatefulWidget {
  const YTLiveDemo({super.key});

  @override
  State<YTLiveDemo> createState() => _YTLiveDemoState();
}

class _YTLiveDemoState extends State<YTLiveDemo> {
  late YoutubePlayerController controller;
  bool isPlayerReady = false;
  @override
  void initState() {
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
              "https://www.youtube.com/watch?v=McbRxhpHAPU") ??
          'NpEaa2P7qZI',
      flags: const YoutubePlayerFlags(
        mute: true,
        isLive: true,
      ),
    );
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Youtube Live Stream")),
      body: YoutubePlayer(
        controller: controller,
        liveUIColor: Colors.amber,
        onReady: () {
          isPlayerReady = true;
        },
        onEnded: (data) {},
      ),
    );
  }
}
