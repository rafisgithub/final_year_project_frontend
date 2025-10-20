import 'package:flutter/material.dart';

class LanguageBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const radius = 8.0; // Border radius
    const gradient = LinearGradient(
      colors: [Color(0xFFFEAA65), Color(0xFFFF5E4F), Color(0xFFD676FF)],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // Border thickness

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
