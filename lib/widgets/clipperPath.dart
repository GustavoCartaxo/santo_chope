import 'package:flutter/material.dart';

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 10.1 * size.height / 12);
    path.lineTo(3 * size.width / 11, 10.1 * size.height / 12);
    path.arcToPoint(Offset(0, 10.1 * size.height / 12),
        clockwise: false, radius: Radius.circular(1.57 * size.width / 11));
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
