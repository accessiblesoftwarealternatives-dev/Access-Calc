import 'package:flutter/material.dart';

class GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) { // all temp basically
    final axisPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1;

    final graphPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      axisPaint,
    );

    final path = Path();
    double scale = 40;

    for (double x = -10; x <= 10; x += 0.1) {
      double y = x * x;

      double screenX = size.width / 2 + x * scale;
      double screenY = size.height / 2 - y * scale;

      if (x == -10) {
        path.moveTo(screenX, screenY);
      } else {
        path.lineTo(screenX, screenY);
      }
    }

    canvas.drawPath(path, graphPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
