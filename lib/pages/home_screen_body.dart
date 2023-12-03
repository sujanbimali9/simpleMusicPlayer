import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:music_player/pages/playerscreen_export.dart';
import 'package:music_player/widgets/custom_card.dart';
import 'package:music_player/widgets/song_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeScreenBody extends StatelessWidget {
  final PlayerController controller;
  const HomeScreenBody({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Text(
            'Enjoy Your Favorite Music',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SearchBar(controller: controller),
          const SectionHeader(
            title: 'Trending Music',
            action: 'View More',
          ),
          CustomCard(controller: controller),
          const SectionHeader(
            title: 'Playlist',
            action: 'View More',
          ),
          SongList(controller: controller),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  const SectionHeader({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: Text(action,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}

class SearchBar extends StatefulWidget {
  final PlayerController controller;
  const SearchBar({super.key, required this.controller});

  @override
  State<SearchBar> createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    List<SongModel> songs = [];
    List<String> filteredSongs = [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 5,
      ),
      child: TextField(
        onTap: () async {
          songs = await widget.controller.audioQuery.querySongs();

          filteredSongs = songs
              .where((song) => song.duration != null && song.duration! >= 10)
              .map((filteredSong) => filteredSong.title)
              .toList();
        },
        onChanged: (value) {
          widget.controller.searchResult = extractTop(
                  query: value,
                  choices: filteredSongs,
                  limit: filteredSongs.length)
              .where((element) => element.score >= 60)
              .map((e) => e.choice)
              .toList()
              .obs;
          print('sujan bimali${widget.controller.searchResult}');
        },
        onSubmitted: (value) {
          Navigator.pushNamed(context, '/search');
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            isDense: true),
      ),
    );
  }
}
