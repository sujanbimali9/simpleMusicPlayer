import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/home.dart';
import 'package:music_player/pages/playerscreen.dart';
import 'package:music_player/pages/playlist.dart';
import 'package:music_player/pages/search.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print(snapshot.data);
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          final bool hasPermission = snapshot.data ?? false;
          print(hasPermission);
          PlayerController controller = Get.put(PlayerController());

          return GetMaterialApp(
            title: 'music player',
            routes: {
              '/home': (context) => HomePage(
                    controller: controller,
                  ),
              '/playlist': (context) => PlayLists(controller: controller),
              '/player': (context) => const PlayerScreen(),
              '/search': (context) {
                return Search(
                  controller: controller,
                );
              }
            },
            home: hasPermission
                ? HomePage(controller: controller)
                : Scaffold(
                    body: Center(
                        child: AlertDialog(
                      title: const Text('Permission denied'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: const Text('cancel'),
                        ),
                        TextButton(
                          child: const Text('open settings'),
                          onPressed: () async {
                            if (await openAppSettings()) {
                              setState(() {
                                hasPermission;
                              });
                            }
                          },
                        )
                      ],
                    )),
                  ),
          );
        }
      },
    );
  }
}

Future<bool> checkPermission() async {
  var status = await Permission.storage.request();
  return status.isGranted;
}
