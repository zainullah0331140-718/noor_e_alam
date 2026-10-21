import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onDone;
  const SplashScreen({super.key, required this.onDone});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1800), widget.onDone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: isDark
                ? [
                    scheme.surface,
                    Color.lerp(scheme.surface, scheme.primary, 0.18)!,
                  ]
                : [
                    scheme.surface,
                    Color.lerp(scheme.surface, scheme.secondary, 0.16)!,
                  ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: MediaQuery.sizeOf(context).height * 0.28,
              child:
                  Text(
                        l10n.bismillah,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'NooriNastaleeq',
                          fontSize: 42,
                          height: 2.2,
                          letterSpacing: 0.5,
                        ).copyWith(color: scheme.primary),
                      )
                      .animate()
                      .fadeIn(duration: 900.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1, 1),
                      ),
            ),
            Positioned(
              bottom: MediaQuery.sizeOf(context).height * 0.22,
              child: Column(
                children: [
                  Icon(
                        Icons.nightlight_round,
                        color: scheme.secondary,
                        size: 28,
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .fadeIn(duration: 600.ms)
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.05, 1.05),
                        duration: 1200.ms,
                      ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.splashStarting,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 700.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
