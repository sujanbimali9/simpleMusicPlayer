import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:music_player/pages/home.dart';
import 'package:music_player/pages/playerscreen.dart';
import 'package:music_player/pages/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.deepPurple, background: Colors.deepPurple),
      //   // useMaterial3: true,
      // ),
      routes: {
        '/home': (context) => const HomePage(),
        '/playlist': (context) {
          final List<Object?> arguments =
              ModalRoute.of(context)!.settings.arguments as List<Object?>;
          final List<PlaylistModel> playlist =
              arguments[0] as List<PlaylistModel>;

          return PlayLists(
            playlist: playlist,
          );
        },
        '/player': (context) {
          final List<Object?> arguments =
              ModalRoute.of(context)!.settings.arguments as List<Object?>;
          final Object? data = arguments[0];

          return PlayerScreen(
            data: data as List<SongModel?>,
          );
        },
      },
      home: const HomePage(),
    );
  }
}
