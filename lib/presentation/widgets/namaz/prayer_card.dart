import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../db/enums.dart';
import '../../../l10n/app_localizations.dart';
import '../prayer_labels.dart';

/// A single prayer row: name + time, a J/A/M segmented selector and the
/// optional sunnah toggles. All taps fire haptics and auto-save.
class PrayerCard extends StatelessWidget {
  final NamazType type;
  final NamazStatus status;
  final String? timeLabel;
  final bool takbeerUla;
  final bool masbooq;
  final bool atMasjid;
  final bool enabled;
  final ValueChanged<NamazStatus> onStatusChanged;
  final void Function({required bool takbeerUla, required bool masbooq, required bool atMasjid})
  onFlagsChanged;

  const PrayerCard({
    super.key,
    required this.type,
    required this.status,
    required this.onStatusChanged,
    required this.onFlagsChanged,
    this.timeLabel,
    this.takbeerUla = false,
    this.masbooq = false,
    this.atMasjid = false,
    this.enabled = true,
  });

  Color _statusColor(ColorScheme scheme) {
    switch (status) {
      case NamazStatus.jamaat:
        return const Color(0xFF1F8F4E);
      case NamazStatus.alone:
        return const Color(0xFFD9B75B);
      case NamazStatus.missed:
        return const Color(0xFFD32F2F);
      case NamazStatus.none:
        return scheme.outlineVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final accent = _statusColor(scheme);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surface,
        border: Border.all(color: accent.withValues(alpha: 0.55), width: 1.4),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  PrayerLabels.namaz(l10n, type),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (timeLabel != null)
                Text(
                  timeLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<NamazStatus>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(
                value: NamazStatus.jamaat,
                label: Text(l10n.jamaat),
                icon: const Icon(Icons.groups, size: 16),
              ),
              ButtonSegment(
                value: NamazStatus.alone,
                label: Text(l10n.alone),
                icon: const Icon(Icons.person, size: 16),
              ),
              ButtonSegment(
                value: NamazStatus.missed,
                label: Text(l10n.missed),
                icon: const Icon(Icons.close, size: 16),
              ),
            ],
            selected: {status},
            onSelectionChanged: enabled
                ? (set) {
                    HapticFeedback.selectionClick();
                    onStatusChanged(set.first);
                  }
                : null,
          ),
          if (status == NamazStatus.jamaat || status == NamazStatus.alone) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FilterChip(
                  label: Text(l10n.takbeerUla),
                  selected: takbeerUla,
                  visualDensity: VisualDensity.compact,
                  onSelected: enabled
                      ? (v) {
                          HapticFeedback.selectionClick();
                          onFlagsChanged(
                            takbeerUla: v,
                            masbooq: masbooq,
                            atMasjid: atMasjid,
                          );
                        }
                      : null,
                ),
                FilterChip(
                  label: Text(l10n.masbooq),
                  selected: masbooq,
                  visualDensity: VisualDensity.compact,
                  onSelected: enabled
                      ? (v) {
                          HapticFeedback.selectionClick();
                          onFlagsChanged(
                            takbeerUla: takbeerUla,
                            masbooq: v,
                            atMasjid: atMasjid,
                          );
                        }
                      : null,
                ),
                FilterChip(
                  avatar: Icon(
                    atMasjid ? Icons.mosque : Icons.home_outlined,
                    size: 16,
                  ),
                  label: Text(
                    atMasjid ? l10n.prayedAtMasjid : l10n.prayedAtHome,
                  ),
                  selected: atMasjid,
                  visualDensity: VisualDensity.compact,
                  onSelected: enabled
                      ? (v) {
                          HapticFeedback.selectionClick();
                          onFlagsChanged(
                            takbeerUla: takbeerUla,
                            masbooq: masbooq,
                            atMasjid: v,
                          );
                        }
                      : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
