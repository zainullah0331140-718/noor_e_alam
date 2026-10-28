import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/app_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/ramadan_providers.dart';
import '../../../utils/numerals.dart';

/// Ramadan meta cards: Sehri/Iftar times, Laylatul Qadr, Itikaf and
/// Zakat/Sadaqah — all backed by the season row.
class RamadanMetaCards extends ConsumerWidget {
  final int seasonId;
  final bool useEastern;

  const RamadanMetaCards({
    super.key,
    required this.seasonId,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seasonAsync = ref.watch(ramadanSeasonProvider(seasonId));

    return seasonAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('$e'),
      data: (season) {
        if (season == null) return const SizedBox.shrink();
        return Column(
          children: [
            _MealTimesCard(season: season, seasonId: seasonId),
            const SizedBox(height: 12),
            _LaylatulQadrCard(season: season, seasonId: seasonId),
            const SizedBox(height: 12),
            _ItikafCard(season: season, seasonId: seasonId),
            const SizedBox(height: 12),
            _ZakatCard(season: season, seasonId: seasonId, useEastern: useEastern),
          ],
        );
      },
    );
  }
}

class _MealTimesCard extends ConsumerWidget {
  final RamadanSeason season;
  final int seasonId;
  const _MealTimesCard({required this.season, required this.seasonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final sehri = season.sehriTime ?? '—';
    final iftar = season.iftarTime ?? '—';

    return Card(
      child: ListTile(
        leading: Icon(Icons.restaurant_outlined, color: scheme.primary),
        title: Text(l10n.ramadanMealTitle),
        subtitle: Text('${l10n.ramadanSehriTime}: $sehri   ·   '
            '${l10n.ramadanIftarTime}: $iftar'),
        trailing: const Icon(Icons.edit_outlined, size: 18),
        onTap: () => _edit(context, ref),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    var sehri = season.sehriTime ?? '';
    var iftar = season.iftarTime ?? '';

    final result = await showDialog<({String? sehri, String? iftar})>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.ramadanSetMealTimes),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '${l10n.ramadanSehriTime} (HH:mm)',
              ),
              controller: TextEditingController(text: sehri),
              onChanged: (v) => sehri = v,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                labelText: '${l10n.ramadanIftarTime} (HH:mm)',
              ),
              controller: TextEditingController(text: iftar),
              onChanged: (v) => iftar = v,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              dialogContext,
              (
                sehri: sehri.trim().isEmpty ? null : sehri.trim(),
                iftar: iftar.trim().isEmpty ? null : iftar.trim(),
              ),
            ),
            child: Text(l10n.saveWord),
          ),
        ],
      ),
    );

    if (result == null || !context.mounted) return;
    await ref.read(ramadanActionsProvider).setMealTimes(
          seasonId: seasonId,
          sehriTime: result.sehri,
          iftarTime: result.iftar,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.ramadanMealTimesSaved)));
  }
}

class _LaylatulQadrCard extends ConsumerWidget {
  final RamadanSeason season;
  final int seasonId;
  const _LaylatulQadrCard({required this.season, required this.seasonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star_border, color: scheme.tertiary),
                const SizedBox(width: 10),
                Text(
                  l10n.ramadanLaylatulQadrTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.ramadanLaylatulQadrBody,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            TextField(
              controller:
                  TextEditingController(text: season.laylatulQadrNote ?? ''),
              decoration: InputDecoration(
                hintText: l10n.ramadanLaylatulQadrHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onSubmitted: (value) async {
                await ref
                    .read(ramadanActionsProvider)
                    .setLaylatulQadrNote(
                      seasonId: seasonId,
                      note: value.trim().isEmpty ? null : value.trim(),
                    );
                if (!context.mounted) return;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(l10n.saveWord)));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ItikafCard extends ConsumerWidget {
  final RamadanSeason season;
  final int seasonId;
  const _ItikafCard({required this.season, required this.seasonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.brightness_2_outlined),
        title: Text(l10n.ramadanItikafTitle),
        subtitle: Text(l10n.ramadanItikafBody),
        value: season.itikafDone,
        onChanged: (v) => ref.read(ramadanActionsProvider).setItikaf(
              seasonId: seasonId,
              value: v,
            ),
      ),
    );
  }
}

class _ZakatCard extends ConsumerWidget {
  final RamadanSeason season;
  final int seasonId;
  final bool useEastern;
  const _ZakatCard({
    required this.season,
    required this.seasonId,
    required this.useEastern,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volunteer_activism_outlined, color: scheme.primary),
                const SizedBox(width: 10),
                Text(
                  l10n.ramadanZakatTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _add(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l10n.ramadanAddAmount),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _amount(
                    context,
                    l10n.ramadanZakatLabel,
                    season.zakatAmount,
                    scheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _amount(
                    context,
                    l10n.ramadanSadaqahLabel,
                    season.sadaqahAmount,
                    scheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _amount(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            formatNum(value, useEastern),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    var input = '';
    var isZakat = true;

    final result = await showDialog<({bool zakat, int amount})>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.ramadanAddAmount),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: true,
                    label: Text(l10n.ramadanZakatLabel),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text(l10n.ramadanSadaqahLabel),
                  ),
                ],
                selected: {isZakat},
                onSelectionChanged: (s) =>
                    setState(() => isZakat = s.first),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.ramadanAmountLabel,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (v) => input = v,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancelWord),
            ),
            FilledButton(
              onPressed: () {
                final amount = int.tryParse(input.trim());
                if (amount == null || amount <= 0) return;
                Navigator.pop(dialogContext, (zakat: isZakat, amount: amount));
              },
              child: Text(l10n.saveWord),
            ),
          ],
        ),
      ),
    );

    if (result == null || !context.mounted) return;
    await ref.read(ramadanActionsProvider).addZakat(
          seasonId: seasonId,
          zakatDelta: result.zakat ? result.amount : null,
          sadaqahDelta: result.zakat ? null : result.amount,
        );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.ramadanAmountSaved)));
  }
}
