import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/pages/widgets/switch.dart';

class PlayLists extends StatelessWidget {
  final Playlist playlist;
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
            SongImage(image: playlist.imageUrl),
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

class Lists extends StatelessWidget {
  final Playlist playlist;
  const Lists({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: playlist.songs.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/player',
                  arguments: [
                    playlist.songs[index],
                    playlist,
                  ],
                );
              },
              title: Text(playlist.songs[index].title,
                  style: const TextStyle(fontSize: 17, color: Colors.white)),
              subtitle: Row(
                children: [
                  Text(
                    playlist.songs[index].description,
                    style: const TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const Text(
                    ' - ',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const Text(
                    'length',
                    style: TextStyle(fontSize: 13, color: Colors.white),
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
