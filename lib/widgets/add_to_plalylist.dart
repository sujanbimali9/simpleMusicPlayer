import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddToPlaylist extends StatelessWidget {
  const AddToPlaylist({super.key, required this.title, required this.songId});
  final String title;
  final int songId;

  Future<void> addToPlaylist(
      String title, int id, PlayerController controller, int playlistId) async {
    await checkSongsInPlayLists(title, id, controller, playlistId)
        ? const Text('a')
        : controller.audioQuery.addToPlaylist(playlistId, songId);
  }

  Future<bool> checkSongsInPlayLists(
      String title, int id, PlayerController controller, int playlistId) async {
    final List<SongModel> playlistAudio = await controller.audioQuery
        .queryAudiosFrom(AudiosFromType.PLAYLIST, playlistId);

    final bool isSongInPlaylist = playlistAudio.any((playlistsong) {
      return playlistsong.title == title;
    });

    return isSongInPlaylist;
  }

  @override
  Widget build(BuildContext context) {
    PlayerController controller = Get.put(
      PlayerController(),
    );

    return FutureBuilder(
      future: controller.audioQuery.queryPlaylists(
        ignoreCase: true,
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {}
        var playlist = snapshot.data;
        return ElevatedButton(
            onPressed: () {
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  overlay.localToGlobal(overlay.size.center(Offset.zero)),
                  overlay.localToGlobal(overlay.size.center(Offset.zero)),
                ),
                Offset.zero & overlay.size,
              );
              showMenu(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                context: context,
                position: position,
                items: playlist!.isEmpty
                    ? [
                        const PopupMenuItem(
                          child: Text('no playlist found'),
                        ),
                        PopupMenuItem(
                          child: const Text('create new playlist'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PlaylistName(
                                controller: controller,
                                audioId: songId,
                              ),
                            );
                          },
                        )
                      ]
                    : [
                        ...playlist
                            .map(
                              (e) => PopupMenuItem(
                                child: Text(e.playlist),
                                onTap: () {
                                  addToPlaylist(
                                    title,
                                    songId,
                                    controller,
                                    e.id,
                                  );
                                },
                              ),
                            )
                            .toList(),
                        PopupMenuItem(
                          child: const Text('create new playlist'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => PlaylistName(
                                controller: controller,
                                audioId: songId,
                              ),
                            );
                          },
                        ),
                      ],
              );
            },
            child: const Text('Add to playlist'));
      },
    );
  }
}

class PlaylistName extends StatelessWidget {
  const PlaylistName(
      {super.key, required this.controller, required this.audioId});
  final PlayerController controller;

  final int audioId;
  @override
  Widget build(BuildContext context) {
    final TextEditingController pressed = TextEditingController();
    bool check = false;

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text('create new playlist'),
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextField(
              controller: pressed,
              onSubmitted: (value) {
                FutureBuilder(
                    future: createPlaylist(value, check),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      check = snapshot.data as bool;
                      return check
                          ? const Text('playlist already exist')
                          : const SizedBox();
                    });
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                  hintText: 'new playlist',
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          check ? const Text('playlist already exist') : const SizedBox(),
        ],
      ),
    );
  }

  Future<bool> createPlaylist(String value, bool check) async {
    var playlist = await controller.audioQuery.queryPlaylists();
    if (playlist.any((element) => element.playlist == value)) {
      check = true;
    } else {
      controller.audioQuery.createPlaylist(value);
      playlist = await controller.audioQuery.queryPlaylists();
      final playlistId =
          playlist.firstWhere((element) => element.playlist == value);

      controller.audioQuery.addToPlaylist(playlistId.id, audioId);
      check = false;
    }
    return check;
  }
}
