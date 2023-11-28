import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  AudioPlayer audioPlayer = AudioPlayer();
  OnAudioQuery audioQuery = OnAudioQuery();

  var playIndex = 0.obs;
  var isPlaying = false.obs;

  var duration = ''.obs;
  var position = ''.obs;

  var max = 0.0.obs;
  var value = 0.0.obs;

  var random = false.obs;
  var repeat = false.obs;

  @override
  void onInit() {
    super.onInit;
    _checkPermission();
  }

  setRandom(bool randomInput) {
    random.value = randomInput;
  }

  setRepeat(bool repeatInput) {
    repeat.value = repeatInput;
  }

  playSong(String? uri, int index) {
    playIndex.value = index;
    try {
      // audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying.value = true;
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

  _checkPermission() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
    } else {
      _checkPermission();
    }
  }
}