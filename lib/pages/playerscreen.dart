import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/playerscreen_export.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlayerScreen extends StatefulWidget {
  final List<SongModel?>? data;

  const PlayerScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final PlayerController controller = Get.put(PlayerController());
  AudioPlayer audioPlayer = AudioPlayer();

  late int index;
  @override
  void initState() {
    index = controller.playIndex.value;
    super.initState();

    audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: widget.data!
            .map(
              (e) => AudioSource.uri(
                Uri.parse(e!.data),
                tag: MediaItem(
                  id: e.id.toString(),
                  album: e.album,
                  title: e.title,
                  artist: e.artist,
                  duration: Duration(milliseconds: e.duration as int),
                ),
              ),
            )
            .toList(),
      ),
      initialIndex: controller.playIndex.value,
    );
    audioPlayer.play();
  }

  IconButton playPauseButton(
    AudioPlayer audioPlayer,
    ProcessingState? processingState,
    bool? playing,
  ) {
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return IconButton(
        icon: const Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.white,
          size: 60,
        ),
        onPressed: audioPlayer.pause,
      );
    } else if (playing != true) {
      return IconButton(
        icon: const Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.white,
          size: 60,
        ),
        onPressed: audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(
          Icons.pause_circle_filled_rounded,
          color: Colors.white,
          size: 60,
        ),
        onPressed: audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: const Icon(
          Icons.replay_circle_filled_rounded,
          color: Colors.white,
          size: 60,
        ),
        onPressed: () => audioPlayer.seek(Duration.zero,
            index: audioPlayer.effectiveIndices!.first),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Stream<PositionData> get positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
    // final playlist = widget.playlist;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }
              // final metadata = state?.currentSource?.tag as MediaItem;
              return Image.asset(
                'assets/images/glass.jpg',
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
              );
            },
          ),
          const BackgroundImage(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                const Spacer(),
                SongDetails(
                  audioPlayer: audioPlayer,
                  // song: widget.data != null
                  //     ? widget.data![index] as SongModel
                  //     : widget.playlist![index] as PlaylistModel,
                ),
                CustomSlider(
                    positionDataStream: positionDataStream,
                    audioPlayer: audioPlayer),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline_rounded),
                      iconSize: 30,
                      color: Colors.white,
                    ),
                    PreviousNextButton(
                      audioPlayer: audioPlayer,
                      icon: const Icon(Icons.skip_previous),
                      onpressed: () {
                        if (audioPlayer.hasPrevious) {
                          index = index - 1;
                          audioPlayer.seekToPrevious();
                        }
                      },
                    ),
                    StreamBuilder<PlayerState>(
                        stream: audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          return playPauseButton(
                              audioPlayer, processingState, playing);
                        }),
                    PreviousNextButton(
                      audioPlayer: audioPlayer,
                      icon: const Icon(Icons.skip_next),
                      onpressed: () {
                        if (audioPlayer.hasNext) {
                          index + 1;
                          audioPlayer.seekToNext();
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.navigate_next_rounded,
                        color: Colors.white,
                      ),
                      iconSize: 30,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
