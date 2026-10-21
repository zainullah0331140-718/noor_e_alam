import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/dashboard_providers.dart';
import '../../providers/nafl_providers.dart';
import '../../providers/namaz_providers.dart';
import '../../providers/settings_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../../utils/numerals.dart';
import '../widgets/charts/donut_chart.dart';
import '../widgets/charts/progress_ring.dart';
import '../widgets/charts/simple_bar_chart.dart';
import '../widgets/common/month_year_toggle.dart';
import '../widgets/dashboard/dashboard_donut_card.dart';

/// Root dashboard: greeting, range toggle, donut cards for Namaz & Nafl,
/// streak strip, weekly bar chart and today's nafl goal ring.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final useEastern = ref.watch(numeralsProvider);
    final dataAsync = ref.watch(dashboardProvider);
    final goal = ref.watch(naflGoalProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _Greeting(),
        const SizedBox(height: 16),
        const Center(child: MonthYearToggle()),
        const SizedBox(height: 18),
        dataAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('$e'),
            ),
          ),
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donut card grid (Namaz + Nafl wired; others show placeholders).
              GridView.count(
                crossAxisCount: MediaQuery.sizeOf(context).width > 640 ? 4 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.62,
                children: [
                  DashboardDonutCard(
                    title: l10n.statPrayers,
                    icon: Icons.mosque,
                    accent: const Color(0xFF1F8F4E),
                    useEastern: useEastern,
                    completion: data.prayers.completion,
                    detail: l10n.detailPrayers(
                      data.prayers.done,
                      data.prayers.total,
                    ),
                    subtitle: l10n.subPrayers(
                      data.prayers.jamaat,
                      data.prayers.alone,
                      data.prayers.missed,
                    ),
                    slices: [
                      DonutSlice(
                        label: l10n.jamaat,
                        value: data.prayers.jamaat.toDouble(),
                        color: const Color(0xFF1F8F4E),
                      ),
                      DonutSlice(
                        label: l10n.alone,
                        value: data.prayers.alone.toDouble(),
                        color: const Color(0xFFD9B75B),
                      ),
                      DonutSlice(
                        label: l10n.missed,
                        value: data.prayers.missed.toDouble(),
                        color: const Color(0xFFD32F2F),
                      ),
                      DonutSlice(
                        label: l10n.remaining,
                        value: (data.prayers.total - data.prayers.done -
                                data.prayers.missed)
                            .clamp(0, data.prayers.total)
                            .toDouble(),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                  DashboardDonutCard(
                    title: l10n.statNafl,
                    icon: Icons.auto_awesome,
                    accent: const Color(0xFF1FB8B8),
                    useEastern: useEastern,
                    completion: data.nafl.completion,
                    detail: l10n.detailRakats(data.nafl.done, data.nafl.total),
                    slices: [
                      DonutSlice(
                        label: l10n.done,
                        value: data.nafl.done.toDouble(),
                        color: const Color(0xFF1FB8B8),
                      ),
                      DonutSlice(
                        label: l10n.notDone,
                        value: (data.nafl.total - data.nafl.done).clamp(
                          0,
                          data.nafl.total,
                        ).toDouble(),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                  DashboardDonutCard(
                    title: l10n.statTilawat,
                    icon: Icons.menu_book,
                    accent: const Color(0xFFB8860B),
                    useEastern: useEastern,
                    completion: data.tilawat.completion,
                    detail: l10n.detailPages(
                      data.tilawat.done,
                      data.tilawat.total,
                    ),
                    slices: [
                      DonutSlice(
                        label: l10n.done,
                        value: data.tilawat.done.toDouble(),
                        color: const Color(0xFFB8860B),
                      ),
                      DonutSlice(
                        label: l10n.notDone,
                        value: (data.tilawat.total - data.tilawat.done).clamp(
                          0,
                          data.tilawat.total,
                        ).toDouble(),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                  DashboardDonutCard(
                    title: l10n.statAzkar,
                    icon: Icons.radio_button_checked,
                    accent: const Color(0xFF6A4C93),
                    useEastern: useEastern,
                    completion: data.azkar.completion,
                    detail: l10n.detailCounts(
                      data.azkar.done,
                      data.azkar.total,
                    ),
                    slices: [
                      DonutSlice(
                        label: l10n.done,
                        value: data.azkar.done.toDouble(),
                        color: const Color(0xFF6A4C93),
                      ),
                      DonutSlice(
                        label: l10n.notDone,
                        value: (data.azkar.total - data.azkar.done).clamp(
                          0,
                          data.azkar.total,
                        ).toDouble(),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                  DashboardDonutCard(
                    title: l10n.statKhatam,
                    icon: Icons.bookmark_added_outlined,
                    accent: const Color(0xFF3D5A80),
                    useEastern: useEastern,
                    completion: data.khatam.completion,
                    detail: l10n.detailCounts(
                      data.khatam.done,
                      data.khatam.total,
                    ),
                    slices: [
                      DonutSlice(
                        label: l10n.done,
                        value: data.khatam.done.toDouble(),
                        color: const Color(0xFF3D5A80),
                      ),
                      DonutSlice(
                        label: l10n.notDone,
                        value: (data.khatam.total - data.khatam.done).clamp(
                          0,
                          data.khatam.total,
                        ).toDouble(),
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              // Streak strip.
              Row(
                children: [
                  Expanded(
                    child: _StreakChip(
                      icon: Icons.local_fire_department,
                      label: l10n.streak,
                      value: l10n.streakValue(data.currentStreak),
                      hint: l10n.streakHint,
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              const SizedBox(height: 18),
              // Today's nafl goal ring.
              _TodayNaflRing(goal: goal, useEastern: useEastern),
              const SizedBox(height: 18),
              const _WeeklyPanel(),
            ],
          ),
        ),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.greetingMorning
        : hour < 17
        ? l10n.greetingAfternoon
        : hour < 21
        ? l10n.greetingEvening
        : l10n.greetingNight;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.appTagline,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StreakChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String hint;
  const _StreakChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(hint, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayNaflRing extends ConsumerWidget {
  final int goal;
  final bool useEastern;
  const _TodayNaflRing({required this.goal, required this.useEastern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateUtilsExt.ymd(DateTime.now());
    final rakatsAsync = ref.watch(naflDayRakatsProvider(today));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            rakatsAsync.when(
              loading: () => const SizedBox(
                width: 84,
                height: 84,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e'),
              data: (rakats) => ProgressRing(
                size: 84,
                stroke: 10,
                progress: goal == 0 ? 0 : rakats / goal,
                centerTop: formatNum(rakats, useEastern),
                centerBottom: '/${formatNum(goal, useEastern)}',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.naflGoal,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.naflRakatsLabel,
                    style: Theme.of(context).textTheme.bodySmall,
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

class _WeeklyPanel extends ConsumerWidget {
  const _WeeklyPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final today = DateUtilsExt.dateOnly(DateTime.now());
    final values = <BarDatum>[];
    // Build the last 7 days from the month map (cheap; keyed cache).
    final monthAsync = ref.watch(namazMonthProvider(today));
    return monthAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('$e'),
      data: (counts) {
        for (var i = 6; i >= 0; i--) {
          final d = today.subtract(Duration(days: i));
          final c = counts[DateUtilsExt.ymd(d)];
          final prayed = (c?.jamaat ?? 0) + (c?.alone ?? 0);
          values.add(
            BarDatum(
              label: _weekday(d),
              value: prayed.toDouble(),
              color: const Color(0xFF1F8F4E),
            ),
          );
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.weeklyTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        l10n.weeklySubtitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                SimpleBarChart(bars: values, height: 160),
              ],
            ),
          ),
        );
      },
    );
  }

  String _weekday(DateTime d) {
    const names = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return names[(d.weekday - 1) % 7];
  }
}
