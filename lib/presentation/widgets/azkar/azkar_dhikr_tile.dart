// One dhikr row: icon, name, optional Arabic subtitle, count/target and progress.
import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// Maps a catalog dhikr key to its localized display name.
String azkarLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'morning':
      return l10n.azkarMorning;
    case 'evening':
      return l10n.azkarEvening;
    case 'tasbeehSubhan':
      return l10n.azkarTasbeehSubhan;
    case 'tasbeehHamd':
      return l10n.azkarTasbeehHamd;
    case 'tasbeehAkbar':
      return l10n.azkarTasbeehAkbar;
    case 'durood':
      return l10n.azkarDurood;
    case 'istighfar':
      return l10n.azkarIstighfar;
    case 'kalima3':
      return l10n.azkarKalima3;
    case 'lailaha':
      return l10n.azkarLailaha;
    case 'ayatulKursi':
      return l10n.azkarAyatulKursi;
    default:
      return key;
  }
}

/// Suggests a leading icon for a dhikr key.
IconData azkarIcon(String key) {
  switch (key) {
    case 'morning':
      return Icons.wb_sunny_outlined;
    case 'evening':
      return Icons.nights_stay_outlined;
    case 'tasbeehSubhan':
      return Icons.radio_button_checked;
    case 'tasbeehHamd':
      return Icons.favorite_border;
    case 'tasbeehAkbar':
      return Icons.flare;
    case 'durood':
      return Icons.wb_twilight;
    case 'istighfar':
      return Icons.trending_down;
    case 'kalima3':
      return Icons.menu_book_outlined;
    case 'lailaha':
      return Icons.auto_awesome;
    case 'ayatulKursi':
      return Icons.shield_outlined;
    default:
      return Icons.radio_button_checked;
  }
}

/// A single dhikr row with count/target and a thin progress bar.
class AzkarDhikrTile extends StatelessWidget {
  final String dhikrKey;
  final String name;
  final int count;
  final int target;
  final String? arabicText;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AzkarDhikrTile({
    super.key,
    required this.dhikrKey,
    required this.name,
    required this.count,
    required this.target,
    this.arabicText,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final progress = target <= 0 ? 0.0 : (count / target).clamp(0.0, 1.0);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: scheme.primaryContainer,
                child: Icon(
                  azkarIcon(dhikrKey),
                  size: 20,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (arabicText != null && arabicText!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        arabicText!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.countOfTarget(count, target),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 64,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: SizedBox(
                        height: 4,
                        child: LinearProgressIndicator(value: progress),
                      ),
                    ),
                  ),
                ],
              ),
              if (onDelete != null) ...[
                const SizedBox(width: 2),
                IconButton(
                  tooltip: l10n.deleteWord,
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 20),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
