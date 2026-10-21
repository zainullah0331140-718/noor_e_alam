import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated circular progress ring, used by the Nafl daily-goal counter.
class ProgressRing extends StatelessWidget {
  final double progress; // 0..1 (values > 1 are clamped for the arc)
  final double size;
  final double stroke;
  final String? centerTop;
  final String? centerBottom;
  final Color? color;

  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 140,
    this.stroke = 14,
    this.centerTop,
    this.centerBottom,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ringColor = color ?? scheme.primary;
    final clamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: Size(size, size),
                painter: _RingPainter(
                  progress: value,
                  stroke: stroke,
                  color: ringColor,
                  trackColor: scheme.surfaceContainerHighest,
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (centerTop != null)
                Text(
                  centerTop!,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.onSurface,
                  ),
                ),
              if (centerBottom != null)
                Text(
                  centerBottom!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final double stroke;
  final Color color;
  final Color trackColor;

  _RingPainter({
    required this.progress,
    required this.stroke,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - stroke) / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor ||
      old.stroke != stroke;
}
