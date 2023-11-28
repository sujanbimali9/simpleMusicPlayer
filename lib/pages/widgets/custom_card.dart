import 'package:get/get.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/pages/playerscreen_export.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return FutureBuilder(
      future: controller.audioQuery.querySongs(
        ignoreCase: true,
        sortType: SongSortType.DURATION,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      ),
      builder: (context, snapshot) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: ListView.builder(
          itemCount: snapshot.data?.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.playIndex = index.obs;
                Navigator.pushNamed(context, '/player',
                    arguments: [snapshot.data]);
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
                              snapshot.data?[index].title == null
                                  ? 'no song found'
                                  : snapshot.data?[index].title as String,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.purple.withOpacity(0.4),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data?[index].artist == null
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
      ),
    );
  }
}
