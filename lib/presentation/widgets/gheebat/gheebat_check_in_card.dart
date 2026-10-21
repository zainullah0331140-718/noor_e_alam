import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/gheebat_providers.dart';
import '../../../utils/date_utils_ext.dart';

/// Daily Gheebat check-in: gheebat-free, slipped or not recorded.
///
/// The card reflects the live row of [day]; tapping an option writes the
/// matching [GheebatStatus] through [GheebatActions.setStatus].
class GheebatCheckInCard extends ConsumerWidget {
  final DateTime day;

  const GheebatCheckInCard({super.key, required this.day});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final status =
        ref.watch(gheebatDayProvider(DateUtilsExt.ymd(day))).value?.status ??
        GheebatStatus.notRecorded;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gheebatTodayTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _StatusChoice(
              icon: Icons.check_circle_outline,
              title: l10n.gheebatFree,
              hint: l10n.gheebatFreeHint,
              accent: const Color(0xFF1F8F4E),
              selected: status == GheebatStatus.free,
              onTap: () => _setStatus(ref, GheebatStatus.free),
            ),
            const SizedBox(height: 10),
            _StatusChoice(
              icon: Icons.error_outline,
              title: l10n.gheebatSlipped,
              hint: l10n.gheebatSlippedHint,
              accent: const Color(0xFFD9B75B),
              selected: status == GheebatStatus.slipped,
              onTap: () => _setStatus(ref, GheebatStatus.slipped),
            ),
            const SizedBox(height: 10),
            _StatusChoice(
              icon: Icons.remove_circle_outline,
              title: l10n.gheebatNotRecorded,
              hint: l10n.gheebatReset,
              accent: scheme.outline,
              selected: status == GheebatStatus.notRecorded,
              onTap: () => _confirmReset(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _setStatus(WidgetRef ref, GheebatStatus status) {
    HapticFeedback.selectionClick();
    ref.read(gheebatActionsProvider).setStatus(day, status);
    _invalidateRelated(ref);
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final actions = ref.read(gheebatActionsProvider);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.gheebatReset),
        content: Text(l10n.gheebatResetConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancelWord),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.done),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    HapticFeedback.selectionClick();
    await actions.reset(day);
    _invalidateRelated(ref);
  }

  /// Keeps the month heatmap, totals, streaks and yearly bars in sync with
  /// the freshly written check-in.
  void _invalidateRelated(WidgetRef ref) {
    ref.invalidate(gheebatMonthStatusProvider(DateTime(day.year, day.month)));
    ref.invalidate(gheebatStatsProvider);
    ref.invalidate(gheebatStreakProvider);
    ref.invalidate(gheebatYearProvider);
  }
}

class _StatusChoice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String hint;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  const _StatusChoice({
    required this.icon,
    required this.title,
    required this.hint,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected
              ? accent.withValues(alpha: 0.16)
              : scheme.surface,
          border: Border.all(
            color: selected
                ? accent
                : scheme.outlineVariant.withValues(alpha: 0.6),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? accent : scheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(hint, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: selected ? accent : scheme.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}
