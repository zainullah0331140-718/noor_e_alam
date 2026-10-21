import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/nafl_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../widgets/charts/progress_ring.dart';
import '../widgets/common/date_selector.dart';
import '../widgets/common/month_year_toggle.dart';
import '../widgets/nafl/nafl_checklist_tile.dart';
import '../widgets/nafl/nafl_custom_dialog.dart';
import '../widgets/nafl/nafl_stats_section.dart';
import '../widgets/prayer_labels.dart';

/// Nafl module: daily checklist + goal ring + stats.
class NaflScreen extends ConsumerStatefulWidget {
  const NaflScreen({super.key});

  @override
  ConsumerState<NaflScreen> createState() => _NaflScreenState();
}

class _NaflScreenState extends ConsumerState<NaflScreen>
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
            children: const [_NaflDayTab(), _NaflStatsTab()],
          ),
        ),
      ],
    );
  }
}

class _NaflDayTab extends ConsumerWidget {
  const _NaflDayTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    final ymd = DateUtilsExt.ymd(day);
    final rowsAsync = ref.watch(naflDayProvider(ymd));
    final rakatsAsync = ref.watch(naflDayRakatsProvider(ymd));
    final goal = ref.watch(naflGoalProvider);
    final useEastern = ref.watch(numeralsProvider);
    final streaks = ref.watch(naflStreaksProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        DateSelector(
          date: day,
          onChanged: (d) => ref.read(selectedDayProvider.notifier).set(d),
        ),
        const SizedBox(height: 16),
        // Goal ring + streaks.
        Center(
          child: rakatsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (rakats) {
              final progress = goal == 0 ? 0.0 : rakats / goal;
              return ProgressRing(
                progress: progress,
                centerTop:
                    '${formatNum(rakats, useEastern)}/${formatNum(goal, useEastern)}',
                centerBottom: AppLocalizations.of(context)!.naflGoal,
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        streaks.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Text('$e'),
          data: (s) => Row(
            children: [
              Expanded(
                child: _MiniStat(
                  icon: Icons.nights_stay_outlined,
                  label: AppLocalizations.of(context)!.streakTahajjud,
                  value: AppLocalizations.of(
                    context,
                  )!.streakValue(s.tahajjud),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  icon: Icons.wb_twilight,
                  label: AppLocalizations.of(context)!.streakDuha,
                  value: AppLocalizations.of(context)!.streakValue(s.duha),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        rowsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (rows) {
            final byKey = {
              for (final r in rows) '${r.naflType.index}:${r.customName}': r,
            };
            final customs = rows
                .where((r) => r.naflType == NaflType.custom)
                .toList();
            return Column(
              children: [
                for (final type in PrayerLabels.fixedNaflTypes) ...[
                  _buildTile(ref, context, row: byKey['${type.index}:'], type: type, day: day),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.naflCustom,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => _addCustom(context, ref, day),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(AppLocalizations.of(context)!.naflAddCustom),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (customs.isEmpty)
                  Text(
                    AppLocalizations.of(context)!.noData,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                for (final r in customs) ...[
                  _buildTile(
                    ref,
                    context,
                    row: r,
                    type: NaflType.custom,
                    day: day,
                    isCustom: true,
                  ),
                  const SizedBox(height: 8),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTile(
    WidgetRef ref,
    BuildContext context, {
    required NaflType type,
    required DateTime day,
    dynamic row,
    bool isCustom = false,
  }) {
    return NaflChecklistTile(
      type: type,
      customName: isCustom ? (row?.customName ?? '') : '',
      done: row?.done ?? false,
      rakats: row?.rakats ?? (isCustom ? 2 : _defaultRakats(type)),
      isCustom: isCustom,
      onDoneChanged: (v) => _save(ref, day, type, isCustom, row,
          done: v, rakats: row?.rakats ?? _defaultRakats(type), note: row?.note),
      onRakatsChanged: (v) => _save(ref, day, type, isCustom, row,
          done: row?.done ?? false, rakats: v, note: row?.note),
      onNoteChanged: (v) => _save(ref, day, type, isCustom, row,
          done: row?.done ?? false,
          rakats: row?.rakats ?? _defaultRakats(type),
          note: v),
      onDelete: isCustom
          ? () => ref
              .read(naflActionsProvider)
              .deleteCustom(day: day, name: row?.customName ?? '')
          : null,
    );
  }

  void _save(
    WidgetRef ref,
    DateTime day,
    NaflType type,
    bool isCustom,
    dynamic row, {
    required bool done,
    required int rakats,
    String? note,
  }) {
    final actions = ref.read(naflActionsProvider);
    if (isCustom) {
      actions.setCustom(
        day: day,
        name: row?.customName ?? '',
        done: done,
        rakats: rakats,
        note: note,
      );
    } else {
      actions.setFixed(
        day: day,
        type: type,
        done: done,
        rakats: rakats,
        note: note,
      );
    }
  }

  int _defaultRakats(NaflType type) {
    switch (type) {
      case NaflType.tahajjud:
        return 2;
      case NaflType.ishraq:
        return 2;
      case NaflType.chasht:
        return 4;
      case NaflType.awwabin:
        return 12;
      case NaflType.sunnahMuakkadah:
        return 12;
      default:
        return 2;
    }
  }

  Future<void> _addCustom(
    BuildContext context,
    WidgetRef ref,
    DateTime day,
  ) async {
    final result = await showNaflCustomDialog(context);
    if (result != null) {
      await ref.read(naflActionsProvider).setCustom(
        day: day,
        name: result.name,
        done: false,
        rakats: result.rakats,
      );
    }
  }
}

class _NaflStatsTab extends ConsumerWidget {
  const _NaflStatsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        const Center(child: MonthYearToggle()),
        const SizedBox(height: 16),
        const NaflStatsSection(),
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
