import 'package:music_player/pages/playerscreen_export.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomCard extends StatelessWidget {
  final PlayerController controller;
  const CustomCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.audioQuery.querySongs(
        ignoreCase: true,
        sortType: SongSortType.DURATION,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
      ),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No songs found'),
          );
        }
        final data = controller.check(snapshot.data!);
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView.builder(
            itemCount: data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  controller.playIndex = index.obs;
                  controller.songs
                      .replaceRange(0, controller.songs.length, data);
                  controller.songs = controller.check(controller.songs).obs;
                  Navigator.pushNamed(
                    context,
                    '/player',
                  );
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width * 0.39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 237, 127, 127),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/glass.jpg'),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      top: 5,
                      bottom: 5,
                      right: 0,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].title,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.purple.withOpacity(0.4),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data[index].artist == null
                                    ? 'Unknown'
                                    : snapshot.data![index].artist as String,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
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
      },
    );
  }
}
