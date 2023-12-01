import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongList extends StatelessWidget {
  final PlayerController controller;
  const SongList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.audioQuery.queryPlaylists(
        ignoreCase: true,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      ),
      builder: (context, snapshot) {
        var playlist = snapshot.data;
        return Expanded(
          child: ListView.builder(
            itemCount: playlist?.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent.withOpacity(0.08),
                ),
                child: ListTile(
                  onTap: () {
                    controller.playIndex = index.obs;
                    controller.playlist
                        .replaceRange(0, controller.playlist.length, playlist!);
                    Navigator.pushNamed(
                      context,
                      '/playlist',
                    );
                  },
                  leading: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purple.withOpacity(0.4),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/glass.jpg'),
                          fit: BoxFit.cover),
                    ),
                    child: const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                      playlist?[index] == null
                          ? 'no song found'
                          : playlist?[index].playlist as String,
                      style:
                          const TextStyle(fontSize: 17, color: Colors.white)),
                  subtitle: Text(
                      playlist?[index] == null
                          ? 'Unknown'
                          : playlist?[index].numOfSongs.toString() as String,
                      style: const TextStyle(color: Colors.white)),
                  trailing: const Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
