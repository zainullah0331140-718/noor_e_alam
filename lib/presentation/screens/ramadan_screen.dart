// Ramadan Hub: 30-day Roza tracker, Taraweeh/Tahajjud, Laylatul Qadr,
// Itikaf, Zakat/Sadaqah and Sehri/Iftar — per Hijri-year season.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import '../../providers/ramadan_providers.dart';
import '../../utils/date_utils_ext.dart';
import '../widgets/ramadan/ramadan_meta_cards.dart';
import '../widgets/ramadan/ramadan_progress_card.dart';
import '../widgets/ramadan/roza_grid.dart';

/// Ramadan Hub module: fasting tracker and the month's core ibadah.
class RamadanScreen extends ConsumerWidget {
  const RamadanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final seasonAsync = ref.watch(ramadanActiveSeasonProvider);
    final streakAsync = ref.watch(ramadanStreakProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Card(
          color: scheme.primaryContainer.withValues(alpha: 0.45),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.nights_stay_outlined, color: scheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.ramadanIntro,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        seasonAsync.when(
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
          data: (season) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HijriHeader(
                hijriYear: season.hijriYear,
                startDate: season.startDate,
                useEastern: useEastern,
              ),
              const SizedBox(height: 16),
              streakAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (streak) => _StreakChip(
                  value: l10n.streakValue(streak.current),
                  best: l10n.streakValue(streak.best),
                  label: l10n.ramadanStreak,
                  hint: l10n.ramadanFastedLabel,
                ),
              ),
              const SizedBox(height: 16),
              RamadanProgressCard(
                seasonId: season.id,
                useEastern: useEastern,
              ),
              const SizedBox(height: 16),
              RamadanQazaCard(seasonId: season.id, useEastern: useEastern),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: RozaGrid(
                    seasonId: season.id,
                    useEastern: useEastern,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              RamadanMetaCards(
                seasonId: season.id,
                useEastern: useEastern,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HijriHeader extends StatelessWidget {
  final int hijriYear;
  final String startDate;
  final bool useEastern;

  const _HijriHeader({
    required this.hijriYear,
    required this.startDate,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final greg = DateUtilsExt.parseYmd(startDate);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.mosque_outlined, color: scheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.ramadanSeasonLabel(hijriYear),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.ramadanStartsOn(DateUtilsExt.pretty(greg)),
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

class _StreakChip extends StatelessWidget {
  final String value;
  final String best;
  final String label;
  final String hint;
  const _StreakChip({
    required this.value,
    required this.best,
    required this.label,
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
            Icon(Icons.local_fire_department, color: scheme.primary, size: 28),
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
                Text(
                  '$hint · $best',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
