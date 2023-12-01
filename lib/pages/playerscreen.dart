import 'package:music_player/pages/playerscreen_export.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final PlayerController controller = Get.put(PlayerController());

  @override
  void initState() {
    super.initState();

    controller.audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children: controller.songs
            .map(
              (e) => AudioSource.uri(
                Uri.parse(e.data),
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
    controller.playSong();
  }

  IconButton playPauseButton(
    PlayerController controller,
    ProcessingState? processingState,
    bool? playing,
  ) {
    AudioPlayer audioPlayer = AudioPlayer();
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return IconButton(
          icon: const Icon(
            Icons.play_circle_fill_rounded,
            color: Colors.white,
            size: 60,
          ),
          onPressed: () {
            controller.audioPlayer.pause();
          });
    } else if (playing != true) {
      return IconButton(
        icon: const Icon(
          Icons.play_circle_fill_rounded,
          color: Colors.white,
          size: 60,
        ),
        onPressed: () {
          controller.audioPlayer.play();
        },
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(
          Icons.pause_circle_filled_rounded,
          color: Colors.white,
          size: 60,
        ),
        onPressed: () {
          controller.audioPlayer.pause();
        },
      );
    } else {
      return IconButton(
          icon: const Icon(
            Icons.replay_circle_filled_rounded,
            color: Colors.white,
            size: 60,
          ),
          onPressed: () {
            audioPlayer.seek(Duration.zero,
                index: audioPlayer.effectiveIndices!.first);
          });
    }
  }

  Stream<PositionData> get positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        controller.audioPlayer.positionStream,
        controller.audioPlayer.bufferedPositionStream,
        controller.audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  Widget build(BuildContext context) {
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
            stream: controller.audioPlayer.sequenceStateStream,
            builder: (context, snapshot) {
              final state = snapshot.data;
              if (state?.sequence.isEmpty ?? true) {
                return const SizedBox();
              }

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
                  controller: controller,
                ),
                CustomSlider(
                  controller: controller,
                  positionDataStream: positionDataStream,
                ),
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
                      icon: const Icon(Icons.skip_previous),
                      onpressed: () {
                        controller.audioPlayer.seekToPrevious();
                      },
                    ),
                    StreamBuilder<PlayerState>(
                        stream: controller.audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;

                          return playPauseButton(controller, processingState,
                              playerState?.playing);
                        }),
                    PreviousNextButton(
                      icon: const Icon(Icons.skip_next),
                      onpressed: () {
                        controller.nextSong();
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
