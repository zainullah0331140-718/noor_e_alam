// Gheebat module: private daily tongue-guard check-in, istighfar counter,
// reflections, statistics and calendar charts.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/gheebat_providers.dart';
import '../../providers/lock_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../widgets/charts/simple_bar_chart.dart';
import '../widgets/gheebat/gheebat_check_in_card.dart';
import '../widgets/gheebat/gheebat_pin_dialog.dart';
import '../widgets/gheebat/gheebat_stats_section.dart';

/// Gheebat (backbiting) tracker screen (module 7).
class GheebatScreen extends ConsumerStatefulWidget {
  const GheebatScreen({super.key});

  @override
  ConsumerState<GheebatScreen> createState() => _GheebatScreenState();
}

class _GheebatScreenState extends ConsumerState<GheebatScreen> {
  DateTime? _rangeMonth;
  DateRange? _range;
  final _noteController = TextEditingController();
  String? _noteFor;

  /// Stable range instance per month so family providers keep their state.
  DateRange _rangeFor(DateTime day) {
    final key = DateTime(day.year, day.month);
    if (_rangeMonth != key) {
      _rangeMonth = key;
      _range = DateRange.monthOf(day);
    }
    return _range!;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final day = ref.watch(selectedDayProvider);
    final range = _rangeFor(day);
    final month = DateTime(day.year, day.month);
    final entry = ref.watch(gheebatDayProvider(DateUtilsExt.ymd(day))).value;
    final lock = ref.watch(appLockProvider);
    final locked = lock.enabled && !ref.watch(appUnlockedProvider);

    // Keep the note field in sync with the selected day / stored row.
    final noteKey = DateUtilsExt.ymd(day);
    if (_noteFor != noteKey) {
      _noteFor = noteKey;
      _noteController.text = entry?.note ?? '';
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          color: scheme.primaryContainer.withValues(alpha: 0.45),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.record_voice_over_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.gheebatIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (locked) ...[_lockedCard(l10n), const SizedBox(height: 16)],
        GheebatCheckInCard(day: day),
        const SizedBox(height: 16),
        _istighfarCard(l10n, day, entry?.istighfarCount ?? 0),
        const SizedBox(height: 16),
        if (locked)
          _lockedNoteCard(l10n)
        else ...[
          _noteCard(l10n, day),
          if (lock.enabled)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () {
                  ref.read(appUnlockedProvider.notifier).lock();
                },
                icon: const Icon(Icons.lock_outline, size: 18),
                label: Text(l10n.gheebatLockNow),
              ),
            ),
        ],
        const SizedBox(height: 16),
        GheebatStatsSection(range: range),
        const SizedBox(height: 16),
        _monthCard(l10n, month),
        const SizedBox(height: 16),
        _yearCard(l10n, day.year, scheme.primary),
      ],
    );
  }

  Future<void> _unlock() async {
    final l10n = AppLocalizations.of(context)!;
    final lock = ref.read(appLockProvider.notifier);
    final pin = await showGheebatPinDialog(
      context,
      title: l10n.gheebatUnlock,
      actionLabel: l10n.gheebatUnlock,
      validate: (pin) => lock.verify(pin) ? null : l10n.gheebatWrongPin,
    );
    if (pin == null) return;
    ref.read(appUnlockedProvider.notifier).unlock();
  }

  Widget _lockedCard(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer.withValues(alpha: 0.45),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_outline, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.gheebatLockedTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.gheebatLockedBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.icon(
                onPressed: _unlock,
                icon: const Icon(Icons.lock_open_outlined),
                label: Text(l10n.gheebatUnlock),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lockedNoteCard(AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notes_outlined, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.gheebatNoteTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.gheebatLockedBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: _unlock,
                icon: const Icon(Icons.lock_open_outlined),
                label: Text(l10n.gheebatUnlock),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _istighfarCard(AppLocalizations l10n, DateTime day, int count) {
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final actions = ref.read(gheebatActionsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gheebatIstighfarTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.gheebatIstighfarHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton.filledTonal(
                  onPressed: count == 0
                      ? null
                      : () {
                          HapticFeedback.selectionClick();
                          actions.addIstighfar(day, delta: -1);
                          _invalidate(day);
                        },
                  icon: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      formatNum(count, useEastern),
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    actions.addIstighfar(day);
                    _invalidate(day);
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _noteCard(AppLocalizations l10n, DateTime day) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gheebatNoteTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: l10n.gheebatNoteHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: () => _saveNote(day),
                icon: const Icon(Icons.save_outlined),
                label: Text(l10n.saveWord),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote(DateTime day) async {
    final l10n = AppLocalizations.of(context)!;
    final note = _noteController.text.trim();
    await ref.read(gheebatActionsProvider).setNote(day, note);
    _invalidate(day);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.gheebatNoteSaved)));
  }

  Widget _monthCard(AppLocalizations l10n, DateTime month) {
    final statusAsync = ref.watch(gheebatMonthStatusProvider(month));
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final first = DateTime(month.year, month.month, 1);
    final leading = (first.weekday - 1) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 18,
                  color: scheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.gheebatCalendarTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            statusAsync.when(
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e'),
              data: (map) {
                final cells = <Widget>[];
                for (var i = 0; i < leading; i++) {
                  cells.add(const SizedBox.shrink());
                }
                for (var d = 1; d <= daysInMonth; d++) {
                  final ymd = DateUtilsExt.ymd(
                    DateTime(month.year, month.month, d),
                  );
                  final status = map[ymd] ?? GheebatStatus.notRecorded;
                  cells.add(
                    _DayCell(
                      day: d,
                      color: _statusColor(status, scheme, isDark),
                    ),
                  );
                }
                return GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: cells,
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _Legend(
                  color: _statusColor(GheebatStatus.free, scheme, isDark),
                  label: l10n.gheebatFree,
                ),
                const SizedBox(width: 12),
                _Legend(
                  color: _statusColor(GheebatStatus.slipped, scheme, isDark),
                  label: l10n.gheebatSlipped,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(GheebatStatus status, ColorScheme scheme, bool isDark) {
    switch (status) {
      case GheebatStatus.free:
        return isDark ? const Color(0xFF2E7D32) : const Color(0xFF1F8F4E);
      case GheebatStatus.slipped:
        return const Color(0xFFD9B75B);
      case GheebatStatus.notRecorded:
        return scheme.surfaceContainerHighest;
    }
  }

  Widget _yearCard(AppLocalizations l10n, int year, Color barColor) {
    final monthsAsync = ref.watch(gheebatYearProvider(year));
    final useEastern = ref.watch(numeralsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
              child: Text(
                l10n.gheebatYearChartTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            monthsAsync.when(
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) =>
                  Padding(padding: const EdgeInsets.all(16), child: Text('$e')),
              data: (months) => SimpleBarChart(
                height: 150,
                bars: [
                  for (var i = 0; i < months.length && i < 12; i++)
                    BarDatum(
                      label: formatNum(i + 1, useEastern),
                      value: months[i].toDouble(),
                      color: barColor,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _invalidate(DateTime day) {
    ref.invalidate(gheebatMonthStatusProvider(DateTime(day.year, day.month)));
    ref.invalidate(gheebatStatsProvider);
    ref.invalidate(gheebatStreakProvider);
    ref.invalidate(gheebatYearProvider);
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final Color color;

  const _DayCell({required this.day, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        '$day',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
