import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/playerscreen_export.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Songs extends StatelessWidget {
  const Songs({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    List<SongModel>? data;

    return FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          sortType: SongSortType.DISPLAY_NAME,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            const Center(
              child: Text('No songs found'),
            );
          } else {
            data = snapshot.data;
          }

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: ListView.builder(
              itemCount: data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/player', arguments: [
                      data,
                      null,
                      index,
                    ]);
                  },
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width * 0.39,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 237, 127, 127),
                      image: const DecorationImage(
                          image: AssetImage('assets/images/glass.jpg'),
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
                                data![index].displayNameWOExt,
                                style: TextStyle(
                                    color: Colors.purple.withOpacity(0.4),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data![index].artist == null
                                    ? 'Unknown'
                                    : data![index].artist as String,
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
        });
  }
}
