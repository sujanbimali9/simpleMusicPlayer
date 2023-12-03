import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/home.dart';
import 'package:music_player/pages/playerscreen.dart';
import 'package:music_player/pages/playlist.dart';
import 'package:music_player/pages/search.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
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

// import 'package:flutter/material.dart';
// import 'package:fuzzywuzzy/fuzzywuzzy.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Fuzzy Search List View'),
//         ),
//         body: SearchableListView(),
//       ),
//     );
//   }
// }

// class SearchableListView extends StatefulWidget {
//   @override
//   _SearchableListViewState createState() => _SearchableListViewState();
// }

// class _SearchableListViewState extends State<SearchableListView> {
//   // Sample list of items
//   List<String> allItems = [
//     'Apple',
//     'Banana',
//     'Cherry',
//     'Date',
//     'Grapes',
//     'Kiwi',
//     'Orange',
//     'Peach',
//     'Pear',
//     'Plum',
//   ];

//   // Filtered items based on user input
//   List filteredItems = [];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height * 0.06,
//           margin: const EdgeInsets.only(top: 10.0, bottom: 5),
//           child: TextField(
//             onTap: () {
//               // Show the list when the TextField is tapped
//               setState(() {
//                 filteredItems = [];
//               });
//             },
//             onChanged: (value) {
//               // Update the filtered items based on fuzzy matching
//               setState(() {
//                 filteredItems = extractTop(
//                   query: value,
//                   choices: allItems,
//                   limit: 5,
//                 );
//               });
//             },
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
//               hintText: 'Search',
//               hintStyle: TextStyle(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: Colors.black.withOpacity(0.5),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(15),
//                 borderSide: BorderSide.none,
//               ),
//               filled: true,
//               isDense: true,
//             ),
//           ),
//         ),
//         if (filteredItems.isNotEmpty)
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredItems.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(filteredItems[index].toString()),
//                   subtitle: Text('Score: ${filteredItems[index].score}'),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
// }
