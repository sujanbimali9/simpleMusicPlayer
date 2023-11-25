import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({
    super.key,
    required this.audioPlayer,
  });

  final AudioPlayer audioPlayer;

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
                stream: audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state?.currentSource!.tag as MediaItem;
                  return Text(
                    metadata.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                },
              ),
              StreamBuilder<SequenceState?>(
                stream: audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state?.currentSource!.tag as MediaItem;

                  return Text(
                    metadata.displayDescription as String,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_outline_sharp,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
