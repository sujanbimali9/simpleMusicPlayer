import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/widgets/add_to_plalylist.dart';

class SongDetails extends StatelessWidget {
  final PlayerController controller;
  const SongDetails({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<SequenceState?>(
                stream: controller.audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state?.currentSource!.tag as MediaItem;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      metadata.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                },
              ),
              StreamBuilder<SequenceState?>(
                stream: controller.audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state?.currentSource!.tag as MediaItem;

                  return Text(
                    metadata.artist ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          StreamBuilder<SequenceState?>(
              stream: controller.audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final metadata = state?.currentSource!.tag as MediaItem;

                return AddToPlaylist(
                  title: metadata.title,
                  songId: int.parse(
                    metadata.id,
                  ),
                );
              }),
        ],
      ),
    );
  }
}
