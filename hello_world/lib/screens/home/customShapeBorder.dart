import 'package:flutter/material.dart';

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {

    Path path = Path();
    path.lineTo(0, rect.height);
    path.cubicTo(
      0, rect.height, 
      rect.width / 2, rect.height + 70,
      rect.width, rect.height);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }
}