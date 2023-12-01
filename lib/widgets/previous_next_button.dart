import 'package:flutter/material.dart';

class PreviousNextButton extends StatelessWidget {
  const PreviousNextButton({
    super.key,
    required this.icon,
    required this.onpressed,
  });

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
