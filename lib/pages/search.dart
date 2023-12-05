import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search extends StatefulWidget {
  final PlayerController controller;
  const Search({super.key, required this.controller});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> filteredSongs = [];
  List<SongModel> song = [];

  Future searchSongs() async {
    song = await widget.controller.audioQuery.querySongs();
    filteredSongs = song
        .where((song) => song.duration != null && song.duration! >= 10)
        .map((filteredSong) => filteredSong.title)
        .toList();
    widget.controller.songs = widget.controller.check(song).obs;
    print(widget.controller.songs);
  }

  @override
  void initState() {
    super.initState();
    searchSongs();
    widget.controller.searchResult = [].obs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade800,
        actions: [
          const SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: TextField(
              onChanged: (value) {
                // print(filteredSongs);
                widget.controller.searchResult = extractTop(
                        query: value,
                        choices: filteredSongs,
                        limit: filteredSongs.length)
                    .where((element) => element.score >= 60)
                    .map((e) => e.choice)
                    .toList()
                    .obs;
                setState(() {
                  widget.controller.searchResult;
                });
                print(widget.controller.searchResult);
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                hintText: widget.controller.searchValue.value,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  if (widget.controller.searchResult.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.controller.searchResult.length,
                        itemBuilder: (context, index) {
                          // print(widget.controller.searchResult);
                          return ListTile(
                            onTap: () {
                              widget.controller.playIndex = widget
                                  .controller.songs
                                  .indexWhere((element) =>
                                      widget.controller.searchResult[index] ==
                                      element.title)
                                  .obs;
                              print('bimali ${widget.controller.playIndex}');
                              print('sujan $song');
                              Navigator.pushNamed(context, '/player');
                            },
                            title: Text(widget.controller.searchResult[index]),
                            subtitle: Text(
                              widget.controller.searchResult[index].toString(),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
