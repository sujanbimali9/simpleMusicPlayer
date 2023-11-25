import 'package:flutter/material.dart';

class Switches extends StatefulWidget {
  const Switches({super.key});

  @override
  State<Switches> createState() => _SwitchesState();
}

class _SwitchesState extends State<Switches> {
  late int pressed;
  final GlobalKey _containerKey = GlobalKey();
  double containerWidth = 0.0;
  @override
  void initState() {
    setState(() {
      pressed = 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _containerKey,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          containerWidth = constraints.maxWidth;
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    pressed = 0;
                  });
                },
                child: Container(
                  width: containerWidth / 2,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(40),
                      left: Radius.circular(28),
                    ),
                    color: pressed == 0
                        ? Colors.deepPurple.withOpacity(0.5)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Play',
                        style: TextStyle(
                          color: pressed == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.play_circle,
                        color: pressed == 0
                            ? Colors.white
                            : Colors.deepPurple.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    pressed = 1;
                  });
                },
                child: Container(
                  width: containerWidth / 2,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(40),
                      right: Radius.circular(28),
                    ),
                    color: pressed == 1
                        ? Colors.deepPurple.withOpacity(0.5)
                        : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Shuffle',
                        style: TextStyle(
                          color: pressed == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.shuffle,
                        color: pressed == 1
                            ? Colors.white
                            : Colors.deepPurple.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
