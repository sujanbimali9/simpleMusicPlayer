import 'package:flutter/material.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/widgets/custom_card.dart';
import 'package:music_player/widgets/song_list.dart';

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
          const _SearchBar(),
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 5,
      ),
      child: TextField(
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
