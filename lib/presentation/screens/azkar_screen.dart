// Azkar module: daily dhikr list + completion ring + custom dhikr + stats tabs.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../db/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/azkar_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/azkar_catalog.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../widgets/azkar/azkar_counter_screen.dart';
import '../widgets/azkar/azkar_custom_dialog.dart';
import '../widgets/azkar/azkar_dhikr_tile.dart';
import '../widgets/azkar/azkar_stats_section.dart';
import '../widgets/charts/progress_ring.dart';
import '../widgets/common/date_selector.dart';
import '../widgets/common/month_year_toggle.dart';

/// Azkar module: daily checklist + tasbeeh counters + stats.
class AzkarScreen extends ConsumerStatefulWidget {
  const AzkarScreen({super.key});

  @override
  ConsumerState<AzkarScreen> createState() => _AzkarScreenState();
}

class _AzkarScreenState extends ConsumerState<AzkarScreen>
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
            children: const [_AzkarDayTab(), _AzkarStatsTab()],
          ),
        ),
      ],
    );
  }
}

class _AzkarDayTab extends ConsumerWidget {
  const _AzkarDayTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final day = ref.watch(selectedDayProvider);
    final ymd = DateUtilsExt.ymd(day);
    final useEastern = ref.watch(numeralsProvider);
    final rowsAsync = ref.watch(azkarDayProvider(ymd));
    final customAsync = ref.watch(azkarCustomProvider);
    final streaks = ref.watch(azkarStreakProvider);

    final rows = rowsAsync.value ?? const <AzkarEntry>[];
    final rowByKey = {for (final r in rows) r.dhikrKey: r};
    final customs = (customAsync.value ?? const <CustomDhikr>[])
        .where((c) => c.active)
        .toList();

    var done = 0;
    var expected = 0;
    var allDailyDone = true;
    for (final item in azkarCatalog) {
      final row = rowByKey[item.key];
      final count = row?.count ?? 0;
      final target = row?.target ?? item.defaultTarget;
      expected += target;
      done += count > target ? target : count;
      if (item.isDaily && count < target) allDailyDone = false;
    }
    for (final c in customs) {
      final row = rowByKey[customDhikrKey(c.id)];
      final count = row?.count ?? 0;
      expected += c.target;
      done += count > c.target ? c.target : count;
    }
    final progress = expected == 0 ? 0.0 : done / expected;

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
              children: [
                ProgressRing(
                  progress: progress,
                  centerTop:
                      '${formatNum((progress * 100).round(), useEastern)}%',
                  centerBottom: l10n.completion,
                ),
                const SizedBox(height: 12),
                streaks.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => Text('$e'),
                  data: (s) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        size: 18,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${l10n.azkarStreak} · ${l10n.streakValue(s.current)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (allDailyDone) ...[
          const SizedBox(height: 8),
          Card(
            color: scheme.primaryContainer.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.azkarAllDone,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        rowsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
          data: (_) => Column(
            children: [
              for (final item in azkarCatalog) ...[
                AzkarDhikrTile(
                  dhikrKey: item.key,
                  name: azkarLabel(l10n, item.key),
                  count: rowByKey[item.key]?.count ?? 0,
                  target: rowByKey[item.key]?.target ?? item.defaultTarget,
                  onTap: () => _openCounter(
                    context,
                    day: day,
                    dhikrKey: item.key,
                    title: azkarLabel(l10n, item.key),
                    target: rowByKey[item.key]?.target ?? item.defaultTarget,
                    initialCount: rowByKey[item.key]?.count ?? 0,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.azkarCustomTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _addCustom(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.azkarAddCustom),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (customAsync.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (customs.isEmpty)
          Text(l10n.noData, style: Theme.of(context).textTheme.bodySmall)
        else
          for (final c in customs) ...[
            AzkarDhikrTile(
              dhikrKey: customDhikrKey(c.id),
              name: c.name,
              count: rowByKey[customDhikrKey(c.id)]?.count ?? 0,
              target: c.target,
              arabicText: c.arabicText,
              onTap: () => _openCounter(
                context,
                day: day,
                dhikrKey: customDhikrKey(c.id),
                title: c.name,
                target: c.target,
                initialCount: rowByKey[customDhikrKey(c.id)]?.count ?? 0,
              ),
              onDelete: () => _deleteCustom(context, ref, c.id),
            ),
            const SizedBox(height: 8),
          ],
      ],
    );
  }

  void _openCounter(
    BuildContext context, {
    required DateTime day,
    required String dhikrKey,
    required String title,
    required int target,
    required int initialCount,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AzkarCounterScreen(
          day: day,
          dhikrKey: dhikrKey,
          title: title,
          target: target,
          initialCount: initialCount,
        ),
      ),
    );
  }

  Future<void> _addCustom(BuildContext context, WidgetRef ref) async {
    final result = await showAzkarCustomDialog(context);
    if (result == null) return;
    await ref
        .read(azkarActionsProvider)
        .addCustom(
          name: result.name,
          arabicText: result.arabicText,
          target: result.target,
          reminderTime: result.reminderTime,
        );
  }

  Future<void> _deleteCustom(
    BuildContext context,
    WidgetRef ref,
    int id,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await ref.read(azkarActionsProvider).removeCustom(id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.azkarDeleted)));
  }
}

class _AzkarStatsTab extends ConsumerWidget {
  const _AzkarStatsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: const [
        Center(child: MonthYearToggle()),
        SizedBox(height: 16),
        AzkarStatsSection(),
      ],
    );
  }
}
