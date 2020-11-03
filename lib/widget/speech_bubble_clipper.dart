import 'package:flutter/material.dart';

class SpeechBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    /// move to middle
    path.moveTo(size.width / 2, 0);

    /// Line to end
    path.lineTo(size.width, 0);

    /// First curve down
    path.quadraticBezierTo(size.width / 2, size.height - 2, 0, size.height);

    /// Second curve up
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width / 2, 0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
