import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_model.dart';
import 'package:music_player/models/song_model.dart';

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
                fontSize: 20,
              ),
            ),
            Text(
              'Enjoy Your Favorite Music',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            _SearchBar(),
            SectionHeader(
              title: 'Trending Music',
              action: 'View More',
            ),
            _CustomCard(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: SectionHeader(
                title: 'Playlist',
                action: 'View More',
              ),
            ),
            _SongsList()
          ],
        ),
      ),
      bottomNavigationBar: const _CustomNavBar(),
    );
  }
}

class _SongsList extends StatelessWidget {
  const _SongsList();

  @override
  Widget build(BuildContext context) {
    List<Playlist> playlists = Playlist.playlists;
    return Expanded(
        child: ListView.builder(
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent.withOpacity(0.08),
          ),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/playlist',
                  arguments: playlists[index]);
            },
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purple.withOpacity(0.4),
                image: DecorationImage(
                    image: NetworkImage(playlists[index].imageUrl),
                    fit: BoxFit.cover),
              ),
              child: const Icon(
                Icons.play_circle_fill_rounded,
                color: Colors.white,
              ),
            ),
            title: Text(playlists[index].title,
                style: const TextStyle(fontSize: 17, color: Colors.white)),
            subtitle: Text(playlists[index].songs.length.toString(),
                style: const TextStyle(color: Colors.white)),
            trailing: const Icon(
              Icons.play_circle_fill_rounded,
              color: Colors.white,
            ),
          ),
        );
      },
    ));
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
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {},
          child: Text(action,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        )
      ],
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard();

  @override
  Widget build(BuildContext context) {
    List<Song> songs = Song.songs;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.26,
      child: ListView.builder(
        itemCount: songs.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/player', arguments: [
                songs[index],
                null,
                index,
              ]);
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 237, 127, 127),
                image: DecorationImage(
                    image: AssetImage(songs[index].coverUrl),
                    fit: BoxFit.cover),
              ),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 8,
                  bottom: 8,
                  right: 5,
                ),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songs[index].title,
                          style: TextStyle(
                              color: Colors.purple.withOpacity(0.4),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          songs[index].description,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.purple,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40,
      margin: const EdgeInsets.symmetric(vertical: 15.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
        ),
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
      iconSize: 40,
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
            icon: Icon(Icons.play_circle_outline_rounded), label: 'Play'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline), label: 'Profile'),
      ],
    );
  }
}
