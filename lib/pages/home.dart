import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/all_songs_screen.dart';
import 'package:music_player/pages/home_screen_body.dart';

class HomePage extends StatefulWidget {
  final PlayerController controller;
  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreenBody(controller: widget.controller),
      Songs(controller: widget.controller),
    ];
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
      body: Obx(
        () => IndexedStack(
          index: widget.controller.bottomIndex.value,
          children: pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          enableFeedback: false,
          onTap: (index) {
            widget.controller.bottomIndex.value = index;
          },
          selectedItemColor: Colors.white,
          currentIndex: widget.controller.bottomIndex.value,
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
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.play_circle_outline_rounded),
            //   label: 'Play',
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.people_outline),
            //   label: 'Profile',
            // ),
          ],
        ),
      ),
    );
  }
}
