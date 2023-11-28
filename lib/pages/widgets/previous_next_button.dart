import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PreviousNextButton extends StatelessWidget {
  const PreviousNextButton({
    super.key,
    required this.audioPlayer,
    required this.icon,
    required this.onpressed,
  });

  final AudioPlayer audioPlayer;
  final Icon icon;
  final VoidCallback? onpressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onpressed,
      icon: icon,
      iconSize: 30,
      color: Colors.white,
    );
  }
}
