import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_providers.dart';
import '../../../providers/muraqaba_providers.dart';
import '../../../utils/date_utils_ext.dart';
import '../../../utils/numerals.dart';

/// Localized label for a Muraqaba time-of-day bucket.
String muraqabaTimeLabel(AppLocalizations l10n, MuraqabaTime time) {
  switch (time) {
    case MuraqabaTime.afterFajr:
      return l10n.muraqabaTimeAfterFajr;
    case MuraqabaTime.tahajjud:
      return l10n.muraqabaTimeTahajjud;
    case MuraqabaTime.morning:
      return l10n.muraqabaTimeMorning;
    case MuraqabaTime.afternoon:
      return l10n.muraqabaTimeAfternoon;
    case MuraqabaTime.evening:
      return l10n.muraqabaTimeEvening;
    case MuraqabaTime.night:
      return l10n.muraqabaTimeNight;
  }
}

/// Icon that matches a Muraqaba time-of-day bucket.
IconData muraqabaTimeIcon(MuraqabaTime time) {
  switch (time) {
    case MuraqabaTime.afterFajr:
      return Icons.wb_twilight;
    case MuraqabaTime.tahajjud:
      return Icons.nightlight_round;
    case MuraqabaTime.morning:
      return Icons.wb_sunny;
    case MuraqabaTime.afternoon:
      return Icons.light_mode_outlined;
    case MuraqabaTime.evening:
      return Icons.wb_shade;
    case MuraqabaTime.night:
      return Icons.dark_mode_outlined;
  }
}

/// Localized duration caption (minutes) using the preferred numeral system.
String muraqabaMinutesLabel(
  AppLocalizations l10n,
  int minutes,
  bool useEastern,
) {
  final text = l10n.muraqabaDuration(minutes);
  return useEastern ? toEastern(text) : text;
}

/// Per-day Muraqaba log: every session with its length, source and note.
class MuraqabaSessionList extends ConsumerWidget {
  final DateTime day;

  const MuraqabaSessionList({super.key, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final useEastern = ref.watch(numeralsProvider);
    final sessionsAsync = ref.watch(muraqabaDayProvider(DateUtilsExt.ymd(day)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.self_improvement, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.muraqabaTodayTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                sessionsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                  data: (sessions) => _PracticeChip(practised: sessions.isNotEmpty),
                ),
              ],
            ),
            const SizedBox(height: 4),
            sessionsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e'),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      l10n.muraqabaTodayEmpty,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final session in sessions)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          muraqabaTimeIcon(session.timeOfDay),
                          color: scheme.primary,
                        ),
                        title: Text(
                          '${muraqabaTimeLabel(l10n, session.timeOfDay)} · '
                          '${muraqabaMinutesLabel(l10n, session.minutes, useEastern)}',
                        ),
                        subtitle: Text(
                          _subtitle(l10n, session.source, session.note),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          tooltip: l10n.deleteWord,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => ref
                              .read(muraqabaActionsProvider)
                              .deleteSession(session.id),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _subtitle(AppLocalizations l10n, String source, String? note) {
    final sourceLabel = source == 'timer'
        ? l10n.muraqabaSourceTimer
        : l10n.muraqabaSourceManual;
    final trimmed = (note ?? '').trim();
    if (trimmed.isEmpty) return sourceLabel;
    return '$sourceLabel · $trimmed';
  }
}

class _PracticeChip extends StatelessWidget {
  final bool practised;

  const _PracticeChip({required this.practised});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final background = practised
        ? scheme.primaryContainer
        : scheme.surfaceContainerHighest;
    final foreground = practised
        ? scheme.onPrimaryContainer
        : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            practised ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: foreground,
          ),
          const SizedBox(width: 6),
          Text(
            practised ? l10n.muraqabaPracticeToday : l10n.muraqabaNoPracticeToday,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
