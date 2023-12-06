import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  OnAudioQuery audioQuery = OnAudioQuery();
  final justAudioBackground = JustAudioBackground();

  RxList<SongModel> songs = <SongModel>[].obs;

  RxList<PlaylistModel> playlist = <PlaylistModel>[].obs;

  RxList searchSongs = [].obs;
  RxList searchResult = [].obs;
  var searchValue = 'search'.obs;

  var filterIndex = 0.obs;
  var bottomIndex = 0.obs;

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  var random = false.obs;
  var repeat = false.obs;

  setRandom(bool randomInput) {
    random.value = randomInput;
  }

  setRepeat(bool repeatInput) {
    repeat.value = repeatInput;
  }

  playSong() {
    try {
      audioPlayer.play();
    } on Exception {
      throw {'error': 'error'};
    }
  }

  pauseSong() {
    audioPlayer.pause();
    isPlaying.value = false;
  }

  previousSong() {
    if (audioPlayer.hasPrevious) {
      playIndex.value--;
      audioPlayer.seekToPrevious();
    }
  }

  nextSong() {
    if (audioPlayer.hasNext) {
      playIndex.value++;
      audioPlayer.seekToNext();
    }
  }

  replaySong() {
    audioPlayer.seek(Duration.zero, index: audioPlayer.effectiveIndices!.first);
  }

  List<SongModel> check(List<SongModel> songs) {
    return songs
        .where((song) => song.duration != null && song.duration! >= 10)
        .toList();
  }
}
