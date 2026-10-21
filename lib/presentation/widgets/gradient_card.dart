import 'package:flutter/material.dart';
import '../../theme/pattern_painter.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool showPattern;
  const GradientCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.showPattern = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  scheme.surface,
                  Color.lerp(scheme.surface, scheme.primary, 0.12)!,
                ]
              : [
                  scheme.surface,
                  Color.lerp(scheme.surface, scheme.secondary, 0.10)!,
                ],
        ),
        border: Border.all(
          color: scheme.primary.withValues(alpha: isDark ? 0.35 : 0.22),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: isDark ? 0.18 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          children: [
            if (showPattern)
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    color: scheme.primary,
                    opacity: isDark ? 0.06 : 0.035,
                  ),
                ),
              ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}
