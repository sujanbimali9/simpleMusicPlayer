import 'package:flutter/material.dart';
import 'package:music_player/controller/controller.dart';

class Search extends StatelessWidget {
  final PlayerController controller;
  const Search({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade800,
        actions: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: TextField(
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                  hintText: controller.searchValue.value,
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: controller.searchResult.length,
                itemBuilder: (context, index) {
                  print(controller.searchResult);
                  return ListTile(
                    onTap: () {},
                    title: Text(controller.searchResult[index]),
                    subtitle: Text(
                      controller.searchResult[index].toString(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
