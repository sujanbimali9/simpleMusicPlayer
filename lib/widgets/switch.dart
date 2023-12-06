import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Switches extends StatefulWidget {
  const Switches({super.key, required this.controller});
  final PlayerController controller;

  @override
  State<Switches> createState() => _SwitchesState();
}

class _SwitchesState extends State<Switches> {
  late int pressed;

  final GlobalKey _containerKey = GlobalKey();

  double containerWidth = 0.0;

  @override
  void initState() {
    pressed = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    songData(List<PlaylistModel> playlist) async {
      final songs = await widget.controller.audioQuery
          .queryAudiosFrom(AudiosFromType.PLAYLIST, playlist[0].id);
      widget.controller.songs = songs.obs;
      widget.controller.playIndex.value = 0;
    }

    playlistData(bool shuffle) async {
      final playlist = await widget.controller.audioQuery.queryPlaylists();
      final shuffledPlaylist = playlist.toList()..shuffle();
      widget.controller.playlist.value = shuffledPlaylist;
      if (playlist.isNotEmpty) {
        if (!shuffle) {
          songData(playlist);
        }
      }
    }

    return Container(
      key: _containerKey,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          containerWidth = constraints.maxWidth;
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  playlistData(false);
                  Navigator.pushNamed(context, '/player');
                },
                child: Container(
                  width: containerWidth / 2,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(40),
                      left: Radius.circular(28),
                    ),
                    color: pressed == 0
                        ? Colors.deepPurple.withOpacity(0.5)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Play',
                        style: TextStyle(
                          color: pressed == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.play_circle,
                        color: pressed == 0
                            ? Colors.white
                            : Colors.deepPurple.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  playlistData(true);
                },
                child: Container(
                  width: containerWidth / 2,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(40),
                      right: Radius.circular(28),
                    ),
                    color: pressed == 1
                        ? Colors.deepPurple.withOpacity(0.5)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shuffle',
                        style: TextStyle(
                          color: pressed == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.shuffle,
                        color: pressed == 1
                            ? Colors.white
                            : Colors.deepPurple.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
