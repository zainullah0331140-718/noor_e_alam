import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/ramadan_providers.dart';
import 'roza_day_tile.dart';

/// A 30-cell grid of Roza day tiles for one season.
class RozaGrid extends ConsumerWidget {
  final int seasonId;
  final bool useEastern;

  const RozaGrid({super.key, required this.seasonId, required this.useEastern});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(ramadanDaysProvider(seasonId));

    return daysAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Text('$e'),
      data: (days) => _grid(context, ref, days),
    );
  }

  Widget _grid(BuildContext context, WidgetRef ref, List<RamadanDay> days) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_view_month_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.ramadanRozaGridTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.95,
          ),
          itemCount: days.length,
          itemBuilder: (context, i) {
            final day = days[i];
            return RozaDayTile(
              seasonId: seasonId,
              dayNumber: day.dayNumber,
              status: day.status,
              taraweeh: day.taraweeh,
              tahajjud: day.tahajjud,
              useEastern: useEastern,
            );
          },
        ),
      ],
    );
  }
}
