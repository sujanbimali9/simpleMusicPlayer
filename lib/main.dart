import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/home.dart';
import 'package:music_player/pages/playerscreen.dart';
import 'package:music_player/pages/playlist.dart';

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
    PlayerController controller = Get.put(PlayerController());
    return GetMaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/home': (context) => HomePage(controller: controller),
        '/playlist': (context) {
          return PlayLists(
            controller: controller,
          );
        },
        '/player': (context) {
          return const PlayerScreen();
        },
      },
      home: HomePage(
        controller: controller,
      ),
    );
  }
}
