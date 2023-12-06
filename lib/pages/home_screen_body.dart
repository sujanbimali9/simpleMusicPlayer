import 'package:music_player/pages/playerscreen_export.dart';
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
          SearchBar(controller: controller),
          SectionHeader(
            title: 'Trending Music',
            action: 'View More',
            allSongs: true,
            controller: controller,
          ),
          CustomCard(controller: controller),
          SectionHeader(
            title: 'Playlist',
            action: 'View More',
            allSongs: false,
            controller: controller,
          ),
          SongList(controller: controller),
        ],
      ),
    );
  }
}

class SectionHeader extends StatefulWidget {
  final PlayerController controller;
  final String title;
  final String action;
  final bool allSongs;
  const SectionHeader({
    super.key,
    required this.controller,
    required this.title,
    required this.action,
    required this.allSongs,
  });

  @override
  State<SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<SectionHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {
            if (widget.allSongs) {
              widget.controller.bottomIndex.value = 1;
              widget.controller.filterIndex.value = 0;
            } else {
              widget.controller.bottomIndex.value = 1;
              widget.controller.filterIndex.value = 1;
            }
          },
          child: Text(widget.action,
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 5,
      ),
      child: TextField(
        onTap: () {
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
