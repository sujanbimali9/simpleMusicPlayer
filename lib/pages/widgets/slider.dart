import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/pages/widgets/slider_position.dart';

class CustomSlider extends StatelessWidget {
  const CustomSlider({
    super.key,
    required this.positionDataStream,
    required this.audioPlayer,
  });

  final Stream<PositionData> positionDataStream;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: positionDataStream,
        builder: (context, snapshot) {
          final positionData = snapshot.data;
          return ProgressBar(
            barHeight: 7,
            baseBarColor: Colors.white,
            thumbColor: Colors.purple.withOpacity(0.8),
            progressBarColor: Colors.purple.withOpacity(0.8),
            thumbGlowRadius: 20,
            timeLabelLocation: TimeLabelLocation.sides,
            total: positionData?.duration ?? Duration.zero,
            progress: positionData?.position ?? Duration.zero,
            buffered: positionData?.bufferedPosition ?? Duration.zero,
            onSeek: audioPlayer.seek,
          );
        });
  }
}
