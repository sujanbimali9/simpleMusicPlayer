import 'package:music_player/pages/playerscreen_export.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class PlayerScreen extends StatefulWidget {
  final Song songs;
  final Playlist? playlist;
  final int? index;

  const PlayerScreen({Key? key, required this.songs, this.playlist, this.index})
      : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    audioPlayer.play();
    widget.playlist == null
        ? audioPlayer.setAudioSource(
            ConcatenatingAudioSource(
              children: [
                AudioSource.uri(
                  Uri.parse('asset:///${widget.songs.url}'),
                  tag: MediaItem(
                      id: widget.songs.title,
                      title: widget.songs.title,
                      artUri: Uri.parse(widget.songs.coverUrl),
                      displayDescription: widget.songs.description),
                ),
                AudioSource.uri(
                  Uri.parse('asset:///${Song.songs[1].url}'),
                  tag: MediaItem(
                      id: Song.songs[1].title,
                      title: Song.songs[1].title,
                      artUri: Uri.parse(Song.songs[1].coverUrl),
                      displayDescription: Song.songs[2].description),
                ),
                AudioSource.uri(
                  Uri.parse('asset:///${Song.songs[2].url}'),
                  tag: MediaItem(
                      id: Song.songs[2].title,
                      title: Song.songs[2].title,
                      artUri: Uri.parse(Song.songs[2].coverUrl),
                      displayDescription: Song.songs[1].description),
                ),
              ],
            ),
          )
        : audioPlayer.setAudioSource(
            ConcatenatingAudioSource(
              children: widget.playlist!.songs
                  .map(
                    (song) => AudioSource.uri(
                      Uri.parse('asset:///${song.url}'),
                      tag: MediaItem(
                        id: song.title,
                        title: song.title,
                        artUri: Uri.parse(song.coverUrl),
                        displayDescription: song.description,
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
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
              final metadata = state?.currentSource!.tag as MediaItem;
              return Image.asset(
                metadata.artUri.toString(),
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
                SongDetails(audioPlayer: audioPlayer),
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
                        audioPlayer.hasNext
                            ? audioPlayer.seekToPrevious()
                            : null;
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
                        audioPlayer.hasNext ? audioPlayer.seekToNext() : null;
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
