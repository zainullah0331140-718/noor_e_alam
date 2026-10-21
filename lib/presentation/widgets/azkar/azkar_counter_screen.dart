// Full-screen tap counter for one dhikr with reset/undo and optional wake lock.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/azkar_providers.dart';
import '../../../utils/numerals.dart';

/// Large tap counter that auto-saves every increment for one dhikr/day.
class AzkarCounterScreen extends ConsumerStatefulWidget {
  final DateTime day;
  final String dhikrKey;
  final String title;
  final int target;
  final int initialCount;

  const AzkarCounterScreen({
    super.key,
    required this.day,
    required this.dhikrKey,
    required this.title,
    required this.target,
    required this.initialCount,
  });

  @override
  ConsumerState<AzkarCounterScreen> createState() => _AzkarCounterScreenState();
}

class _AzkarCounterScreenState extends ConsumerState<AzkarCounterScreen> {
  late int _count = widget.initialCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(azkarKeepAwakeProvider)) {
        WakelockPlus.enable();
      }
    });
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  void _tap() {
    HapticFeedback.lightImpact();
    if (ref.read(azkarSoundProvider)) {
      SystemSound.play(SystemSoundType.click);
    }
    setState(() => _count++);
    ref
        .read(azkarActionsProvider)
        .increment(
          day: widget.day,
          dhikrKey: widget.dhikrKey,
          target: widget.target,
        );
  }

  void _undo() {
    if (_count <= 0) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _count--);
    ref
        .read(azkarActionsProvider)
        .setCount(
          day: widget.day,
          dhikrKey: widget.dhikrKey,
          count: _count,
          target: widget.target,
        );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.azkarUndoDone)));
  }

  Future<void> _reset() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.azkarReset),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.azkarReset),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _count = 0);
    ref
        .read(azkarActionsProvider)
        .setCount(
          day: widget.day,
          dhikrKey: widget.dhikrKey,
          count: 0,
          target: widget.target,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.azkarResetDone)));
  }

  void _toggleKeepAwake(bool value) {
    ref.read(azkarKeepAwakeProvider.notifier).set(value);
    if (value) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final keepAwake = ref.watch(azkarKeepAwakeProvider);
    final sound = ref.watch(azkarSoundProvider);
    final progress = widget.target <= 0
        ? 0.0
        : (_count / widget.target).clamp(0.0, 1.0);
    final reached = widget.target > 0 && _count >= widget.target;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.azkarCounterTitle),
        actions: [
          IconButton(
            tooltip: l10n.azkarKeepAwake,
            isSelected: keepAwake,
            selectedIcon: const Icon(Icons.lightbulb),
            onPressed: () => _toggleKeepAwake(!keepAwake),
            icon: const Icon(Icons.lightbulb_outline),
          ),
          IconButton(
            tooltip: l10n.azkarSound,
            isSelected: sound,
            selectedIcon: const Icon(Icons.volume_up),
            onPressed: () => ref.read(azkarSoundProvider.notifier).set(!sound),
            icon: const Icon(Icons.volume_up_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox(
                      height: 6,
                      child: LinearProgressIndicator(value: progress),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final size = math.min(240.0, constraints.maxWidth);
                          return GestureDetector(
                            onTap: _tap,
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: scheme.primaryContainer,
                                border: Border.all(
                                  color: scheme.primary.withValues(alpha: 0.4),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    formatNum(_count, useEastern),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: scheme.onPrimaryContainer,
                                        ),
                                  ),
                                  Text(
                                    '/${formatNum(widget.target, useEastern)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: scheme.onPrimaryContainer
                                              .withValues(alpha: 0.7),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: reached
                            ? Text(
                                l10n.azkarTargetReached,
                                key: const ValueKey('reached'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      color: scheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            : const SizedBox.shrink(key: ValueKey('empty')),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.azkarTapToCount,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.azkarReset),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: _count > 0 ? _undo : null,
                      icon: const Icon(Icons.undo),
                      label: Text(l10n.azkarUndo),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
