// Muraqaba module: quiet timer, daily log, statistics and practice charts.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/muraqaba_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../widgets/charts/simple_bar_chart.dart';
import '../widgets/muraqaba/muraqaba_heatmap.dart';
import '../widgets/muraqaba/muraqaba_session_list.dart';
import '../widgets/muraqaba/muraqaba_stats_section.dart';
import '../widgets/muraqaba/muraqaba_timer_card.dart';

/// Muraqaba module: meditation timer, session log, stats and charts.
class MuraqabaScreen extends ConsumerStatefulWidget {
  const MuraqabaScreen({super.key});

  @override
  ConsumerState<MuraqabaScreen> createState() => _MuraqabaScreenState();
}

class _MuraqabaScreenState extends ConsumerState<MuraqabaScreen> {
  static const int _maxManualMinutes = 180;

  MuraqabaTime _timeOfDay = MuraqabaTime.afterFajr;
  DateTime? _rangeMonth;
  DateRange? _range;

  /// Stable range instance per month so the family providers keep their state.
  DateRange _rangeFor(DateTime day) {
    final key = DateTime(day.year, day.month);
    if (_rangeMonth != key) {
      _rangeMonth = key;
      _range = DateRange.monthOf(day);
    }
    return _range!;
  }

  Future<void> _openManualLog() async {
    final l10n = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    var minutesInput = '';
    var noteInput = '';

    final result = await showDialog<_ManualLogInput>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.muraqabaLogManual),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.muraqabaCustomMinutes,
                ),
                onChanged: (value) => minutesInput = value,
                validator: (value) {
                  final n = int.tryParse((value ?? '').trim());
                  if (n == null || n < 1 || n > _maxManualMinutes) {
                    return l10n.muraqabaCustomMinutes;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(labelText: l10n.muraqabaSessionNote),
                onChanged: (value) => noteInput = value,
              ),
            ],
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
              final note = noteInput.trim();
              Navigator.pop(
                dialogContext,
                _ManualLogInput(
                  minutes: int.parse(minutesInput.trim()),
                  note: note.isEmpty ? null : note,
                ),
              );
            },
            child: Text(l10n.saveWord),
          ),
        ],
      ),
    );

    if (result == null || !mounted) return;
    await ref
        .read(muraqabaActionsProvider)
        .addSession(
          day: ref.read(selectedDayProvider),
          minutes: result.minutes,
          timeOfDay: _timeOfDay,
          note: result.note,
          source: 'manual',
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.muraqabaSessionSaved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final day = ref.watch(selectedDayProvider);
    final range = _rangeFor(day);
    final month = DateTime(day.year, day.month);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          color: scheme.primaryContainer.withValues(alpha: 0.45),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.spa_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.muraqabaIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        MuraqabaTimerCard(
          timeOfDay: _timeOfDay,
          onTimeOfDayChanged: (time) => setState(() => _timeOfDay = time),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton.tonalIcon(
            onPressed: _openManualLog,
            icon: const Icon(Icons.edit_note),
            label: Text(l10n.muraqabaLogManual),
          ),
        ),
        const SizedBox(height: 16),
        MuraqabaSessionList(day: day),
        const SizedBox(height: 16),
        MuraqabaStatsSection(range: range),
        const SizedBox(height: 16),
        _heatmapCard(l10n, month, range),
        const SizedBox(height: 16),
        _yearCard(l10n, day.year, scheme.primary),
        const SizedBox(height: 16),
        _guideCard(l10n),
      ],
    );
  }

  Widget _heatmapCard(
    AppLocalizations l10n,
    DateTime month,
    DateRange range,
  ) {
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
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.muraqabaHeatmapTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            MuraqabaHeatmap(month: month, range: range),
          ],
        ),
      ),
    );
  }

  Widget _yearCard(AppLocalizations l10n, int year, Color barColor) {
    final monthsAsync = ref.watch(muraqabaYearProvider(year));
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
                l10n.muraqabaYearChartTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            monthsAsync.when(
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('$e'),
              ),
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

  Widget _guideCard(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.muraqabaGuideTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              l10n.muraqabaGuideBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

/// Minutes and note captured by the manual-log dialog.
class _ManualLogInput {
  final int minutes;
  final String? note;

  const _ManualLogInput({required this.minutes, this.note});
}
