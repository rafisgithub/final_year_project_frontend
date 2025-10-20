import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderPainter extends CustomPainter {
  final bool hasError;

  CustomBorderPainter({this.hasError = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (hasError) return;
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFA865),
          Color(0xFFFF5E4F),
          Color(0xFFD676FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(16.r));

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
