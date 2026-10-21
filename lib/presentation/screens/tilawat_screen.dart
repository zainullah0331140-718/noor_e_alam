import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/tilawat_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../widgets/charts/progress_ring.dart';
import '../widgets/common/date_selector.dart';
import '../widgets/common/month_year_toggle.dart';
import '../widgets/tilawat/tilawat_entry_list.dart';
import '../widgets/tilawat/tilawat_position_card.dart';
import '../widgets/tilawat/tilawat_stats_section.dart';

/// Tilawat module: daily recitation log, goal ring, position card + stats.
class TilawatScreen extends ConsumerStatefulWidget {
  const TilawatScreen({super.key});

  @override
  ConsumerState<TilawatScreen> createState() => _TilawatScreenState();
}

class _TilawatScreenState extends ConsumerState<TilawatScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.rangeToday),
            Tab(text: l10n.moduleReports),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [_TilawatDayTab(), _TilawatStatsTab()],
          ),
        ),
      ],
    );
  }
}

class _TilawatDayTab extends ConsumerStatefulWidget {
  const _TilawatDayTab();

  @override
  ConsumerState<_TilawatDayTab> createState() => _TilawatDayTabState();
}

class _TilawatDayTabState extends ConsumerState<_TilawatDayTab> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late TilawatUnit _unit;

  @override
  void initState() {
    super.initState();
    _unit = ref.read(tilawatUnitProvider);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addEntry(DateTime day) {
    final l10n = AppLocalizations.of(context)!;
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount < 1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.tilawatAmountInvalid)));
      return;
    }
    final note = _noteController.text.trim();
    ref
        .read(tilawatActionsProvider)
        .addEntry(
          day: day,
          unit: _unit,
          amount: amount,
          note: note.isEmpty ? null : note,
        );
    _amountController.clear();
    _noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final useEastern = ref.watch(numeralsProvider);
    final day = ref.watch(selectedDayProvider);
    final entriesAsync = ref.watch(tilawatDayProvider(DateUtilsExt.ymd(day)));
    final unit = ref.watch(tilawatUnitProvider);
    final goal = ref.watch(tilawatGoalProvider);
    final streaks = ref.watch(tilawatStreakProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        DateSelector(
          date: day,
          onChanged: (d) => ref.read(selectedDayProvider.notifier).set(d),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tilawatGoalTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Center(
                  child: entriesAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Text('$e'),
                    data: (entries) {
                      final done = entries.fold(
                        0,
                        (s, e) => s + (e.unit == unit ? e.amount : 0),
                      );
                      return ProgressRing(
                        progress: goal == 0 ? 0.0 : done / goal,
                        centerTop:
                            '${formatNum(done, useEastern)}/${formatNum(goal, useEastern)}',
                        centerBottom: tilawatUnitLabel(l10n, unit),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                streaks.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text('$e'),
                  data: (s) => Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.local_fire_department_outlined,
                          label: l10n.currentStreak,
                          value: l10n.streakValue(s.current),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MiniStat(
                          icon: Icons.emoji_events_outlined,
                          label: l10n.bestStreak,
                          value: l10n.streakValue(s.best),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tilawatLogTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TilawatUnit>(
                  initialValue: _unit,
                  decoration: InputDecoration(labelText: l10n.tilawatUnitLabel),
                  items: [
                    for (final u in TilawatUnit.values)
                      DropdownMenuItem(
                        value: u,
                        child: Text(tilawatUnitLabel(l10n, u)),
                      ),
                  ],
                  onChanged: (u) {
                    if (u == null) return;
                    setState(() => _unit = u);
                    ref.read(tilawatUnitProvider.notifier).set(u);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.tilawatAmountLabel,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(labelText: l10n.naflNoteLabel),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _addEntry(day),
                    child: Text(l10n.tilawatAddEntry),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const TilawatPositionCard(),
        const SizedBox(height: 16),
        Text(
          l10n.tilawatEntriesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TilawatEntryList(date: day),
      ],
    );
  }
}

class _TilawatStatsTab extends ConsumerWidget {
  const _TilawatStatsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        const Center(child: MonthYearToggle()),
        const SizedBox(height: 16),
        const TilawatStatsSection(),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: scheme.primary),
            const SizedBox(height: 6),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
