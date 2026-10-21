import 'package:flutter/material.dart';

class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double opacity;
  IslamicPatternPainter({required this.color, this.opacity = 0.04});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final step = 40.0;
    final path = Path();
    for (double y = -step; y < size.height + step; y += step * 1.5) {
      for (double x = -step; x < size.width + step; x += step) {
        path.moveTo(x, y);
        path.lineTo(x + step / 2, y + step / 2);
        path.lineTo(x + step, y);
        path.lineTo(x + step / 2, y - step / 2);
        path.close();
      }
    }
    canvas.drawPath(path, paint);
    final paint2 = Paint()
      ..color = color.withValues(alpha: opacity * 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (double y = 0; y < size.height; y += step * 2) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint2);
    }
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}
