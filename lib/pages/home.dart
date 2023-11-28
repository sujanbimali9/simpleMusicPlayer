import 'package:flutter/material.dart';
import 'package:music_player/pages/widgets/custom_card.dart';
import 'package:music_player/pages/widgets/song_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade800,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: CircleAvatar(backgroundColor: Colors.white),
          )
        ],
        leading: const Icon(
          Icons.grid_view_rounded,
          color: Colors.white,
        ),
      ),
      body: Container(
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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Enjoy Your Favorite Music',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            _SearchBar(),
            SectionHeader(
              title: 'Trending Music',
              action: 'View More',
            ),
            CustomCard(),
            SectionHeader(
              title: 'Playlist',
              action: 'View More',
            ),
            SongList(),
          ],
        ),
      ),
      bottomNavigationBar: const _CustomNavBar(),
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

class _CustomNavBar extends StatefulWidget {
  const _CustomNavBar();

  @override
  State<_CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<_CustomNavBar> {
  late int currentindex;

  @override
  void initState() {
    super.initState();
    currentindex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      enableFeedback: false,
      onTap: (index) {
        setState(() {
          currentindex = index;
        });
      },
      selectedItemColor: Colors.white,
      currentIndex: currentindex,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      backgroundColor: Colors.deepPurple.shade800,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      type: BottomNavigationBarType.fixed,
      iconSize: 20,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'home'),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark_border_rounded,
          ),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline_rounded),
          label: 'Play',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
