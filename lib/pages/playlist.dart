import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/widgets/switch.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayLists extends StatelessWidget {
  final List<PlaylistModel> playlist;
  const PlayLists({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade800,
        // actions: [PopUp()],
        title: const Text(
          'Playlist',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade200,
            ],
          ),
        ),
        child: Column(
          children: [
            const SongImage(image: 'https://picsum.photos/200/300'),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Song Name',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Switches(),
            Lists(playlist: playlist),
          ],
        ),
      ),
    );
  }
}

class Lists extends StatefulWidget {
  final List<PlaylistModel> playlist;
  const Lists({super.key, required this.playlist});

  @override
  State<Lists> createState() => _ListsState();
}

class _ListsState extends State<Lists> {
  loadPlaylist(PlayerController controller) async {
    final selectedPlaylist = widget.playlist[controller.playIndex.value];
    final playlistSongs = await controller.audioQuery.queryAudiosFrom(
      AudiosFromType.PLAYLIST,
      selectedPlaylist.id,
      sortType: SongSortType.DURATION,
      ignoreCase: true,
    );
    final List<SongModel> playlist = [];
    playlist.addAll(playlistSongs);
    return playlist;
  }

  late PlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(PlayerController());
    loadPlaylist(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.playlist.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                controller.playIndex = index.obs;
                final List<SongModel> playlist = loadPlaylist(controller);
                Navigator.pushNamed(
                  context,
                  '/player',
                  arguments: [playlist],
                );
              },
              title: Text(widget.playlist[index].playlist,
                  style: const TextStyle(fontSize: 17, color: Colors.white)),
              subtitle: Row(
                children: [
                  Text(
                    widget.playlist[index].playlist,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const Text(
                    ' - ',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  Text(
                    widget.playlist[index].numOfSongs.toString(),
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
              leading: Text(
                (index + 1).toString(),
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
              trailing: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            );
          }),
    );
  }
}

class SongImage extends StatelessWidget {
  final String image;
  const SongImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high),
        ),
      ),
    );
  }
}
