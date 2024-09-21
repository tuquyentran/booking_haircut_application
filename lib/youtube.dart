import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'config/const.dart';

class Youtube extends StatefulWidget {
  const Youtube({super.key});

  @override
  State<Youtube> createState() => _YoutubeState();
}

class _YoutubeState extends State<Youtube> {
  final video = "https://www.youtube.com/watch?v=EM5wq2vXw4A";
  late YoutubePlayerController controller;
  @override
  void initState() {
    super.initState();
    final videourl = YoutubePlayer.convertUrlToId(video);
    controller = YoutubePlayerController(
        initialVideoId: videourl!,
        flags: const YoutubePlayerFlags(autoPlay: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(urlBackground),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              YoutubePlayer(
                controller: controller,
                showVideoProgressIndicator: true,
                onReady: () => debugPrint('Ready'),
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                  ),
                  const PlaybackSpeedButton()
                ],
              )
            ],
          ),
        ),
      ],
    ));
  }
}
