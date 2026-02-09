

import 'package:flutter/material.dart';

class GridBackground extends StatelessWidget {
  const GridBackground({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.white.withOpacity(0.08)..strokeWidth = 1.0;
    double step = 35;
    for (double i = 0; i < size.width; i += step) { canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint); }
    for (double i = 0; i < size.height; i += step) { canvas.drawLine(Offset(0, i), Offset(size.width, i), paint); }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}