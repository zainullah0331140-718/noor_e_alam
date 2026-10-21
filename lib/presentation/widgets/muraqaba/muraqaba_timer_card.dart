// Background-safe meditation timer: elapsed time is always derived from
// wall-clock timestamps, so it stays correct while the app is suspended.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/muraqaba_providers.dart';
import '../../../providers/settings_providers.dart';
import '../../../utils/numerals.dart';
import 'muraqaba_session_list.dart' show muraqabaTimeLabel;

/// Quiet timer card: presets, time-of-day picker and the running clock.
class MuraqabaTimerCard extends ConsumerStatefulWidget {
  final MuraqabaTime timeOfDay;
  final ValueChanged<MuraqabaTime> onTimeOfDayChanged;

  const MuraqabaTimerCard({
    super.key,
    required this.timeOfDay,
    required this.onTimeOfDayChanged,
  });

  @override
  ConsumerState<MuraqabaTimerCard> createState() =>
      _MuraqabaTimerCardState();
}

class _MuraqabaTimerCardState extends ConsumerState<MuraqabaTimerCard>
    with WidgetsBindingObserver {
  static const List<int> _presetMinutes = [5, 10, 15, 20];
  static const int _minCustomMinutes = 1;
  static const int _maxCustomMinutes = 180;

  DateTime? _startedAt;
  Duration _accumulated = Duration.zero;
  bool _running = false;
  int? _targetMinutes;
  bool _bellRung = false;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _ticker = null;
    unawaited(_setWakelock(false));
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    if (!mounted) return;
    if (_running) {
      _startTicker();
    }
    setState(() {});
  }

  /// Elapsed time computed from the stored timestamps — never from ticks.
  Duration get _elapsed {
    final start = _startedAt;
    if (!_running || start == null) return _accumulated;
    final delta = DateTime.now().difference(start);
    return _accumulated + (delta.isNegative ? Duration.zero : delta);
  }

  void _start() {
    setState(() {
      _startedAt = DateTime.now();
      _accumulated = Duration.zero;
      _running = true;
      _bellRung = false;
    });
    _startTicker();
    unawaited(_setWakelock(true));
  }

  void _pause() {
    setState(() {
      _accumulated = _elapsed;
      _startedAt = null;
      _running = false;
    });
    _stopTicker();
    unawaited(_setWakelock(false));
  }

  void _resume() {
    setState(() {
      _startedAt = DateTime.now();
      _running = true;
    });
    _startTicker();
    unawaited(_setWakelock(true));
  }

  void _reset() {
    setState(() {
      _accumulated = Duration.zero;
      _startedAt = null;
      _running = false;
      _bellRung = false;
    });
    _stopTicker();
    unawaited(_setWakelock(false));
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context)!;
    final elapsed = _elapsed;
    final minutes = math.max(1, (elapsed.inSeconds / 60).ceil());
    final day = ref.read(selectedDayProvider);

    await ref
        .read(muraqabaActionsProvider)
        .addSession(
          day: day,
          minutes: minutes,
          timeOfDay: widget.timeOfDay,
          source: 'timer',
        );

    if (!mounted) return;
    _reset();
    unawaited(SystemSound.play(SystemSoundType.alert));
    await HapticFeedback.mediumImpact();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.muraqabaSessionSaved)));
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      _ringBellIfTargetReached();
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _ringBellIfTargetReached() {
    final target = _targetMinutes;
    if (target == null || _bellRung || !_running) return;
    if (_elapsed.inSeconds < target * 60) return;
    _bellRung = true;
    unawaited(SystemSound.play(SystemSoundType.alert));
    unawaited(HapticFeedback.mediumImpact());
  }

  Future<void> _setWakelock(bool enabled) async {
    try {
      if (enabled) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (_) {}
  }

  Future<void> _openCustomMinutes() async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    var input = _targetMinutes?.toString() ?? '';

    final minutes = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.muraqabaCustomMinutes),
        content: Form(
          key: formKey,
          child: TextFormField(
            autofocus: true,
            keyboardType: TextInputType.number,
            initialValue: _targetMinutes?.toString(),
            decoration: InputDecoration(labelText: l10n.muraqabaCustomMinutes),
            onChanged: (value) => input = value,
            validator: (value) {
              final n = int.tryParse((value ?? '').trim());
              if (n == null || n < _minCustomMinutes || n > _maxCustomMinutes) {
                return l10n.muraqabaCustomMinutes;
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              Navigator.pop(dialogContext, int.parse(input.trim()));
            },
            child: Text(l10n.saveWord),
          ),
        ],
      ),
    );

    if (minutes == null) return;
    setState(() {
      _targetMinutes = minutes;
      _bellRung = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final elapsed = _elapsed;
    final target = _targetMinutes;
    final progress = target == null || target == 0
        ? 0.0
        : (elapsed.inSeconds / (target * 60)).clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.muraqabaTimerTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _formatElapsed(elapsed, useEastern),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              ),
            ),
            if (target != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(value: progress),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.muraqabaDuration(target),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.muraqabaPresetLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final minutes in _presetMinutes)
                  ChoiceChip(
                    label: Text(l10n.muraqabaDuration(minutes)),
                    selected: target == minutes,
                    onSelected: (selected) => setState(() {
                      _targetMinutes = selected ? minutes : null;
                      _bellRung = false;
                    }),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.tune, size: 18),
                  label: Text(l10n.muraqabaCustomMinutes),
                  onPressed: _openCustomMinutes,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.muraqabaTimeLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final time in MuraqabaTime.values)
                  ChoiceChip(
                    label: Text(muraqabaTimeLabel(l10n, time)),
                    selected: widget.timeOfDay == time,
                    onSelected: (selected) {
                      if (!selected) return;
                      widget.onTimeOfDayChanged(time);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (_running)
                  FilledButton.icon(
                    onPressed: _pause,
                    icon: const Icon(Icons.pause),
                    label: Text(l10n.muraqabaPause),
                  )
                else if (elapsed > Duration.zero)
                  FilledButton.icon(
                    onPressed: _resume,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.muraqabaResume),
                  )
                else
                  FilledButton.icon(
                    onPressed: _start,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.muraqabaStart),
                  ),
                FilledButton.tonalIcon(
                  onPressed: elapsed > Duration.zero ? _finish : null,
                  icon: const Icon(Icons.check),
                  label: Text(l10n.muraqabaFinish),
                ),
                OutlinedButton.icon(
                  onPressed:
                      elapsed > Duration.zero || _running ? _reset : null,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.muraqabaResetTimer),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// `mm:ss`, or `h:mm:ss` once the session passes one hour.
  String _formatElapsed(Duration duration, bool useEastern) {
    final total = math.max(0, duration.inSeconds);
    final hours = total ~/ 3600;
    final minutes = (total % 3600) ~/ 60;
    final seconds = total % 60;
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    if (hours > 0) {
      return '${_digits(hours.toString(), useEastern)}:'
          '${_digits(mm, useEastern)}:${_digits(ss, useEastern)}';
    }
    return '${_digits(mm, useEastern)}:${_digits(ss, useEastern)}';
  }

  String _digits(String value, bool useEastern) {
    if (!useEastern) return value;
    return value.split('').map((char) {
      final digit = int.tryParse(char);
      return digit == null ? char : formatNum(digit, true);
    }).join();
  }
}
