import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songs extends StatefulWidget {
  final PlayerController controller;
  const Songs({super.key, required this.controller});

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    List<Widget> filter = [
      AllSongs(controller: widget.controller),
      SongsByPlaylist(controller: widget.controller),
      SongsByAlubm(controller: widget.controller),
    ];
    return Container(
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
          Row(
            children: [
              Obx(
                () => TextButton(
                  onPressed: () {
                    widget.controller.filterIndex.value = 0;
                  },
                  child: Text(
                    'All Songs',
                    style: TextStyle(
                      color: widget.controller.filterIndex.value == 0
                          ? Colors.white
                          : Colors.white60,
                    ),
                  ),
                ),
              ),
              Obx(
                () => TextButton(
                    onPressed: () {
                      widget.controller.filterIndex.value = 1;
                    },
                    child: Text(
                      'Playlist',
                      style: TextStyle(
                        color: widget.controller.filterIndex.value == 1
                            ? Colors.white
                            : Colors.white60,
                      ),
                    )),
              ),
              Obx(
                () => TextButton(
                  onPressed: () {
                    widget.controller.filterIndex.value = 2;
                  },
                  child: Text(
                    'Album',
                    style: TextStyle(
                      color: widget.controller.filterIndex.value == 2
                          ? Colors.white
                          : Colors.white60,
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: widget.controller.filterIndex.value,
                children: filter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AllSongs extends StatelessWidget {
  const AllSongs({
    super.key,
    required this.controller,
  });

  final PlayerController controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.audioQuery.querySongs(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No songs found'),
            );
          } else {
            final data = controller.check(snapshot.data!);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].title),
                  subtitle: Text(data[index].artist ?? 'Unknown'),
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://picsum.photos/200/300'),
                  ),
                  onTap: () {
                    controller.playIndex = index.obs;
                    controller.songs = controller.check(data).obs;
                    Navigator.pushNamed(
                      context,
                      '/player',
                    );
                  },
                );
              },
            );
          }
        });
  }
}

class SongsByPlaylist extends StatelessWidget {
  const SongsByPlaylist({super.key, required this.controller});
  final PlayerController controller;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.audioQuery.queryPlaylists(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                collapsedIconColor: Colors.white38,
                title: ListTile(
                  title: Text(data![index].playlist),
                  subtitle:
                      Text("Songs : ${data[index].numOfSongs.toString()}"),
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://picsum.photos/200/300'),
                  ),
                  onTap: () {
                    controller.playIndex = index.obs;
                  },
                ),
                children: [
                  FutureBuilder(
                      future: controller.audioQuery.queryAudiosFrom(
                          AudiosFromType.PLAYLIST, data[index].id),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else {
                          final data = snapshot.data;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(data![index].title),
                                subtitle: Text(data[index].artist ?? 'Unknown'),
                                leading: const CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      'https://picsum.photos/200/300'),
                                ),
                                // trailing: AddToPlaylist(
                                //   title: data[index].title,
                                //   songId: data[index].id,
                                // ),
                                onTap: () {
                                  controller.playIndex = index.obs;
                                  controller.songs = controller.check(data).obs;
                                  Navigator.pushNamed(
                                    context,
                                    '/player',
                                  );
                                },
                              );
                            },
                          );
                        }
                      }),
                ],
              );
            },
          );
        }
      },
    );
  }
}

class SongsByAlubm extends StatelessWidget {
  const SongsByAlubm({super.key, required this.controller});
  final PlayerController controller;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.audioQuery.queryAlbums(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          final data = snapshot.data;
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                collapsedIconColor: Colors.white38,
                title: ListTile(
                  title: Text(data![index].album),
                  subtitle:
                      Text("Songs : ${data[index].numOfSongs.toString()}"),
                  leading: const CircleAvatar(
                    backgroundImage:
                        NetworkImage('https://picsum.photos/200/300'),
                  ),
                  onTap: () {
                    controller.playIndex = index.obs;
                  },
                ),
                children: [
                  FutureBuilder(
                    future: controller.audioQuery.queryAudiosFrom(
                        AudiosFromType.ALBUM_ID, data[index].id),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else {
                        final data = snapshot.data;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(data![index].title),
                              subtitle: Text(data[index].artist ?? 'Unknown'),
                              leading: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://picsum.photos/200/300'),
                              ),
                              // trailing: AddToPlaylist(
                              //   title: data[index].title,
                              //   songId: data[index].id,
                              // ),
                              onTap: () {
                                controller.playIndex = index.obs;
                                controller.songs = controller.check(data).obs;
                                Navigator.pushNamed(
                                  context,
                                  '/player',
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
