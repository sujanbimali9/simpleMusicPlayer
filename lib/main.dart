import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/models/song_model.dart';
import 'package:music_player/pages/home.dart';
import 'package:music_player/pages/playerscreen.dart';
import 'package:music_player/pages/playlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.deepPurple, background: Colors.deepPurple),
      //   // useMaterial3: true,
      // ),
      routes: {
        '/home': (context) => const HomePage(),
        '/playlist': (context) {
          final Playlist playlist =
              ModalRoute.of(context)!.settings.arguments as Playlist;
          return PlayLists(
            playlist: playlist,
          );
        },
        '/player': (context) {
          final List<Object?> arguments =
              ModalRoute.of(context)!.settings.arguments as List<Object?>;
          final Song songs = arguments[0] as Song;
          final Playlist? playlist = arguments[1] as Playlist?;
          // final int index = arguments[2] as int;
          return PlayerScreen(
            songs: songs,
            playlist: playlist,
            // index: index,
          );
        },
      },

      home: const HomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
